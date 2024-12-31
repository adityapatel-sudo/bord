//
//  CanvasView.swift
//  bord
//
//  Created by Aditya Patel on 12/15/24.
//

import SwiftUI

/**
 A view that displays the canvas and handles user interactions.
 - Parameters:
 - canvasVM: The view model that holds the canvas items.
 - modeVM: The view model that holds the current mode.
 - canvasSize: The size of the canvas.
 
 The canvas view is the main view that displays the canvas and handles user interactions. It uses the `Canvas`
 view to draw the grid or lines, the lines, and the background. It also uses the `EditableTextView` view to
 display and edit text items. The canvas view handles user interactions such as scrolling, dragging, and drawing
 based on the current mode.
 
 The canvas view is used in the `ContentView` view.
 
 ```swift
 CanvasView(canvasVM: CanvasItemsViewModel(), modeVM: CanvasModeViewModel(panOffset: .zero))
 ```
 */
struct CanvasView: View {
    @ObservedObject var canvasVM: CanvasItemsViewModel
    @ObservedObject var modeVM: CanvasModeViewModel

    var canvasSize: CGSize = CGSize(
        width: (NSScreen.main?.frame.width ?? 1600) * 3,
        height: (NSScreen.main?.frame.height ?? 900) * 3
    )

    var body: some View {
        ZStack {
            Canvas { context, screenSize in
                drawGridOrLines(context, screenSize)
                drawLines(&context)
                drawBackground(context, screenSize)
            }
            .onScrollWheelUp { deltaX, deltaY in
                handleScroll(deltaX * 3, deltaY * 3)
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
            ForEach(canvasVM.texts) { text in
                EditableTextView(
                    canvasVM: canvasVM,
                    modeVM: modeVM,
                    text: text,
                    temporaryText: text.text
                )
            }
        }
    }

    fileprivate func drawGridOrLines(_ context: GraphicsContext, _ screenSize: CGSize) {
        if modeVM.gridMode == .grid {
            drawGrid(context, screenSize)
        } else if modeVM.gridMode == .lines {
            drawHorizontalLines(context, screenSize)
        }
    }

    private func drawLines(_ context: inout GraphicsContext) {
        // Draw the lines, translated by the current pan offset
        context.translateBy(x: modeVM.currentPanOffset.width, y: modeVM.currentPanOffset.height)
        for line in canvasVM.lines {
            let strokeStyle = line == canvasVM.selectedPath ?
                StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, dash: [line.lineWidth * 5]) :
                StrokeStyle(lineWidth: line.lineWidth, lineCap: .round)
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

    private func drawGrid(
        _ context: GraphicsContext,
        _ size: CGSize,
        _ gridSpacing: CGFloat.Stride = CGFloat.Stride(50)
    ) {
        // Draw horizontal lines
        drawHorizontalLines(context, size, gridSpacing)

        // Draw vertical lines
        for xLines in stride(from: modeVM.currentPanOffset.width, through: size.width, by: gridSpacing) {
            let startPoint = CGPoint(x: xLines, y: 0)
            let endPoint = CGPoint(x: xLines, y: size.height)
            context.stroke(
                Path { path in
                    path.move(to: startPoint)
                    path.addLine(to: endPoint)
                },
                with: .color(.gray),
                lineWidth: 0.5
            )
        }
    }

    private func drawHorizontalLines(
        _ context: GraphicsContext,
        _ size: CGSize,
        _ gridSpacing: CGFloat.Stride = CGFloat.Stride(50)
    ) {
        for yLines in stride(from: modeVM.currentPanOffset.height, through: size.height, by: gridSpacing) {
            let startPoint = CGPoint(x: 0, y: yLines)
            let endPoint = CGPoint(x: size.width, y: yLines)
            context.stroke(
                Path { path in
                    path.move(to: startPoint)
                    path.addLine(to: endPoint)
                },
                with: .color(.gray),
                lineWidth: 0.5
            )
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
    private func handleDragChanged(_ value: DragGesture.Value) {
        let offsetPoint = CGPoint(
                x: value.location.x - modeVM.currentPanOffset.width,
                y: value.location.y - modeVM.currentPanOffset.height
            )
        switch modeVM.mode {
        case .draw:
            switch canvasVM.drawEndMode {
            case .plain:
                canvasVM.newDraw(point: offsetPoint)
            case .arrow:
                canvasVM.newDrawnArrow(point: offsetPoint)
            case .twoEndArrow:
                canvasVM.newTwpDrawnArrow(point: offsetPoint)
            }
        case .erase:
            handleEraseStroke(offsetPoint)
        case .select:
            handleSelectStroke(value, offsetPoint)
        case .line:
            canvasVM.newLine(point: offsetPoint)
        case .arrow:
            canvasVM.newArrow(point: offsetPoint)
        case .rectangle:
            canvasVM.newRectangle(point: offsetPoint)
        case .elipse:
            canvasVM.newEllipse(point: offsetPoint)
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

    // swiftlint:disable:next cyclomatic_complexity
    private func handleDragEnded(_ value: DragGesture.Value) {
        let offsetPoint = CGPoint(
                x: value.location.x - modeVM.currentPanOffset.width,
                y: value.location.y - modeVM.currentPanOffset.height
            )
        switch modeVM.mode {
        case .draw:
            switch canvasVM.drawEndMode {
            case .plain:
                canvasVM.endDraw()
            case .arrow:
                canvasVM.endDrawnArrow()
            case .twoEndArrow:
                canvasVM.endTwoDrawnArrow()
            }
        case .erase:
            for line in canvasVM.lines where line.path.contains(offsetPoint) {
                canvasVM.remove(line: line)
            }
        case .select:
            canvasVM.isMoving = false
        case .line:
            canvasVM.endLine(point: offsetPoint)
        case .arrow:
            canvasVM.endArrow(point: offsetPoint)
        case .rectangle:
            canvasVM.endRectangle(point: offsetPoint)
        case .elipse:
            canvasVM.endEllipse(point: offsetPoint)
        case .pan:
            modeVM.panOffset.width += value.translation.width
            modeVM.panOffset.height += value.translation.height
        case .text:
            canvasVM.newText(at: offsetPoint)
        default:
            break
        }
    }

    fileprivate func handleSelectStroke(_ value: DragGesture.Value, _ offsetPoint: CGPoint) {
        if !canvasVM.isMoving {
            canvasVM.currentMoveOffset = value.location
            canvasVM.selectedPath = canvasVM.lines.last(where: { line in
                let strokedPath = line.path.cgPath.copy(
                    strokingWithWidth: line.lineWidth + 20,
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

    fileprivate func handleEraseStroke(_ offsetPoint: CGPoint) {
        if let line = canvasVM.lines.last(where: { line in
            let strokedPath = line.path.cgPath.copy(
                strokingWithWidth: line.lineWidth + 20
                ,
                lineCap: .round,
                lineJoin: .round,
                miterLimit: 0
            )
            return strokedPath.contains(offsetPoint)
        }) {
            canvasVM.remove(line: line)
        }
        if let text = canvasVM.texts.last(where: { text in
            return  text.position.x - 0.5 * text.width <= offsetPoint.x &&
            text.position.y - 0.5 * text.height <= offsetPoint.y &&
            text.position.x + 0.5 * text.width >= offsetPoint.x &&
            text.position.y + 0.5 * text.height >= offsetPoint.y
        }) {
            canvasVM.remove(text: text)
        }
    }

    private func handleScroll(_ deltaX: CGFloat, _ deltaY: CGFloat) {
        modeVM.currentPanOffset.width += deltaX
        modeVM.currentPanOffset.height += deltaY

        modeVM.panOffset.width += deltaX
        modeVM.panOffset.height += deltaY
    }
}

#Preview {
    CanvasView(canvasVM: CanvasItemsViewModel(), modeVM: CanvasModeViewModel(panOffset: .zero))
}
