//
//  CanvasView.swift
//  bord
//
//  Created by Aditya Patel on 12/15/24.
//

import SwiftUI

struct CanvasView: View {
    @ObservedObject var lineVM: LineViewModel
    @ObservedObject var modeVM: CanvasModeViewModel
    
    var canvasSize: CGSize = CGSize(
        width: NSScreen.main?.frame.width ?? 1600,
        height: NSScreen.main?.frame.height ?? 900
    )

    let outsideCanvasColor: Color = .black
    var body: some View {
        GeometryReader { geometry in
            let screenSize = geometry.size
            Canvas { context, size in
                // Draw the lines, translated by the current pan offset
                context.translateBy(x: modeVM.currentPanOffset.width, y: modeVM.currentPanOffset.height)
                for line in lineVM.lines {
                    let strokeStyle = StrokeStyle(lineWidth: line.lineWidth, lineCap: .round)
                    context.stroke(
                        line.path,
                        with: .color(line.color),
                        style: strokeStyle
                    )
                }

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
                    with: .color(outsideCanvasColor),
                    style: FillStyle(eoFill: true)
                )
            }
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged(handleDragChanged)
                    .onEnded(handleDragEnded)
            )
            .background(ColorManager.backgroundColor)
        }
    }
    private func handleDragChanged(_ value: DragGesture.Value) {
        if modeVM.mode == .draw || modeVM.mode == .erase{
            // Handle drawing or erasing
            let offsetPoint = CGPoint(
                    x: value.location.x - modeVM.currentPanOffset.width,
                    y: value.location.y - modeVM.currentPanOffset.height
                )
            lineVM.newDraw(point: offsetPoint)
        } else if modeVM.mode == .line {
            lineVM.newLine(point: value.location)
        } else if modeVM.mode == .pan {
            // Handle panning
            let newOffset = CGSize(
                width: modeVM.panOffset.width + value.translation.width,
                height: modeVM.panOffset.height + value.translation.height
            )
            // Clamp the pan offset to the canvas
            modeVM.currentPanOffset.width = min(max(newOffset.width, -canvasSize.width), canvasSize.width)
            modeVM.currentPanOffset.height = min(max(newOffset.height, -canvasSize.height), canvasSize.height)
        }

    }
    private func handleDragEnded(_ value: DragGesture.Value) {
        if modeVM.mode == .draw || modeVM.mode == .erase {
            lineVM.drawEnded()
        } else if modeVM.mode == .line {
            lineVM.endLine(point: value.location)
        } else if modeVM.mode == .pan {
            modeVM.panOffset.width += value.translation.width
            modeVM.panOffset.height += value.translation.height
        }
    }
    private func handleScroll(delta: CGSize) {
        modeVM.currentPanOffset.width += delta.width
        modeVM.currentPanOffset.height += delta.height
        print("Scrolling handling")
    }
}

#Preview {
    CanvasView(lineVM: LineViewModel(), modeVM: CanvasModeViewModel())
}
