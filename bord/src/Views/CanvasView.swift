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
                    if newValue != .select {
                        canvasVM.isMoving = false
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
        case .draw:
            canvasVM.newDraw(point: offsetPoint)
        case .erase:
            if let line = canvasVM.getLines().last(where: { line in
                let strokedPath = line.path.cgPath.copy(
                    strokingWithWidth: 40,
                    lineCap: .round,
                    lineJoin: .round,
                    miterLimit: 0
                )
                return strokedPath.contains(offsetPoint)
            }) {
                canvasVM.remove(item: line)
            }
        case .select:
            handleMoveChanged(value, offsetPoint)
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
        case .draw:
            canvasVM.endDraw()
        case .erase:
            for line in canvasVM.getLines() where line.path.contains(offsetPoint) {
                canvasVM.remove(item: line)
            }
        case .select:
            canvasVM.isMoving = false
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

    fileprivate func handleMoveChanged(_ value: DragGesture.Value, _ offsetPoint: CGPoint) {
        if !canvasVM.isMoving {
            let lines = canvasVM.getLines()
            canvasVM.currentMoveOffset = value.location
            canvasVM.selectedPath = lines.last(where: { line in
                let strokedPath = line.path.cgPath.copy(
                    strokingWithWidth: 40,
                    lineCap: .round,
                    lineJoin: .round,
                    miterLimit: 0
                )
                return strokedPath.contains(offsetPoint)
            })
        } else {
            if let line = canvasVM.selectedPath as? LineModel {
                let curDiff = CGSize(
                    width: value.location.x - canvasVM.currentMoveOffset.x,
                    height: value.location.y - canvasVM.currentMoveOffset.y
                )
                canvasVM.currentMoveOffset = value.location
                canvasVM.moveLine(line, by: curDiff)
            }
        }
        canvasVM.isMoving = true
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
