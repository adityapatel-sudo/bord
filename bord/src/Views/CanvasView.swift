//
//  CanvasView.swift
//  bord
//
//  Created by Aditya Patel on 12/15/24.
//

import SwiftUI

struct CanvasView: View {
    @ObservedObject var canvasVM: CanvasItemsViewModel
    @ObservedObject var modeVM: CanvasModeViewModel

    var canvasSize: CGSize = CGSize(
        width: NSScreen.main?.frame.width ?? 1600,
        height: NSScreen.main?.frame.height ?? 900
    )

    var body: some View {
        GeometryReader { geometry in
            let screenSize = geometry.size
            ZStack {
                Canvas { context, _ in
                    drawLines(&context)
                    drawBackground(context, screenSize)
                }
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged(handleDragChanged)
                        .onEnded(handleDragEnded)
                )
                .onChange(of: modeVM.mode) { _, newValue in
                    if newValue != .drag {
                        canvasVM.isDragging = false
                        canvasVM.selectedPath = nil
                    }
                }

                .background(ColorManager.backgroundColor)
            }
        }
    }

    private func drawLines(_ context: inout GraphicsContext) {
        // Draw the lines, translated by the current pan offset
        context.translateBy(x: modeVM.currentPanOffset.width, y: modeVM.currentPanOffset.height)
        for line in canvasVM.getLines() {
            var strokeStyle = StrokeStyle(lineWidth: line.lineWidth, lineCap: .round)
            if line == canvasVM.selectedPath {
                strokeStyle = StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, dash: [line.lineWidth * 5])
            }
            context.stroke(
                line.path,
                with: .color(line.color),
                style: strokeStyle
            )
        }
    }

    private func drawBackground(_ context: GraphicsContext, _ screenSize: CGSize) {
        // Draw a black rectangle around the canvas to show the canvas boundary
        let canvasRect = CGRect(origin: .zero, size: canvasSize)
        let screenRect = CGRect(
            origin: CGPoint(x: -modeVM.currentPanOffset.width, y: -modeVM.currentPanOffset.height),
            size: screenSize
        )
        var canvasPath = Path()
        canvasPath.addRect(screenRect)
        canvasPath.addRect(canvasRect)
        context.fill(
            canvasPath,
            with: .color(ColorManager.uneditableBackground),
            style: FillStyle(eoFill: true)
        )
    }

    private func handleDragChanged(_ value: DragGesture.Value) {
        let offsetPoint = CGPoint(
                x: value.location.x - modeVM.currentPanOffset.width,
                y: value.location.y - modeVM.currentPanOffset.height
            )
        switch modeVM.mode {
        case .draw, .erase:
            canvasVM.newDraw(point: offsetPoint)
        case .drag:
            if !canvasVM.isDragging {
                let lines = canvasVM.getLines()
                canvasVM.curentDragOffset = value.location
                canvasVM.selectedPath = lines.last(where: { line in
                    let strokedPath = line.path.cgPath.copy(
                        strokingWithWidth: 20,
                        lineCap: .round,
                        lineJoin: .round,
                        miterLimit: 0
                    )
                    return strokedPath.contains(offsetPoint)
                })
            } else {
                if let line = canvasVM.selectedPath as? LineModel {
                    let curDiff = CGSize(
                        width: value.location.x - canvasVM.curentDragOffset.x,
                        height: value.location.y - canvasVM.curentDragOffset.y
                    )
                    canvasVM.curentDragOffset = value.location
                    canvasVM.moveLine(line, by: curDiff)
                }
            }
            canvasVM.isDragging = true
        case .line:
            canvasVM.newLine(point: offsetPoint)
        case .rectangle:
            canvasVM.newRectangle(point: offsetPoint)
        case .pan:
            // Handle panning
            let newOffset = CGSize(
                width: modeVM.panOffset.width + value.translation.width,
                height: modeVM.panOffset.height + value.translation.height
            )
            // Clamp the pan offset to the canvas
            modeVM.currentPanOffset.width = min(max(newOffset.width, -canvasSize.width), canvasSize.width)
            modeVM.currentPanOffset.height = min(max(newOffset.height, -canvasSize.height), canvasSize.height)
        default:
            break
        }
    }
    private func handleDragEnded(_ value: DragGesture.Value) {
        let offsetPoint = CGPoint(
                x: value.location.x - modeVM.currentPanOffset.width,
                y: value.location.y - modeVM.currentPanOffset.height
            )
        switch modeVM.mode {
        case .draw, .erase:
            canvasVM.endDraw()
        case .drag:
            canvasVM.isDragging = false
        case .line:
            canvasVM.endLine(point: offsetPoint)
        case .rectangle:
            canvasVM.endRectangle(point: offsetPoint)
        case .pan:
            modeVM.panOffset.width += value.translation.width
            modeVM.panOffset.height += value.translation.height
        default:
            break
        }
    }
    private func handleScroll(delta: CGSize) {
        modeVM.currentPanOffset.width += delta.width
        modeVM.currentPanOffset.height += delta.height
        print("Scrolling handling")
    }
}

#Preview {
    CanvasView(canvasVM: CanvasItemsViewModel(), modeVM: CanvasModeViewModel())
}
