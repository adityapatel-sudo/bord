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
//                drawBackground(context, screenSize)
            }
            .onScrollWheelUp { deltaX, deltaY in
                handleScroll(deltaX * 3, deltaY * 3)
            }
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .modifiers(.command)
                    .onChanged {value in handleDragChanged(value, isCMDPressed: true)}
                    .onEnded {value in handleDragEnded(value, isCMDPressed: true)}
            )
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged {value in handleDragChanged(value, isCMDPressed: false)}
                    .onEnded {value in handleDragEnded(value, isCMDPressed: false)}
            )
            .highPriorityGesture(MagnifyGesture()
                .onChanged { value in modeVM.magnify(by: value) }
            )
            .onChange(of: modeVM.mode) { _, newValue in
                if newValue != .select {
                    canvasVM.unselectAll()
                    canvasVM.isMoving = false
                    canvasVM.selectedPath = nil
                }
            }
            .onChange(of: canvasVM.thickness) { _, _ in
                canvasVM.updateSelectedThickness()
            }
            .background(ColorManager.backgroundColor)
            // draw selection boxes
            SelectView(canvasVM: canvasVM, modeVM: modeVM)
            // draw texts
            ForEach(canvasVM.texts) { text in
                EditableTextView(
                    canvasVM: canvasVM,
                    modeVM: modeVM,
                    text: text,
                    temporaryText: text.text
                )
            }
        }
        .scaleEffect(modeVM.zoom)
        .clipped()
        .frame(width: canvasSize.width, height: canvasSize.height)
    }
}

#Preview {
    CanvasView(canvasVM: CanvasItemsViewModel(), modeVM: CanvasModeViewModel(panOffset: .zero))
}
