//
//  DrawingToolbarView.swift
//  bord
//
//  Created by Aditya Patel on 12/25/24.
//

import SwiftUI

struct DrawingToolbarView: View {
    @ObservedObject var canvasModeVM: CanvasModeViewModel
    @ObservedObject var canvasVM: CanvasItemsViewModel
    @State var prevColor: Color?
    @State var prevSize: CGFloat?

    var body: some View {
        HStack(spacing: 0) {
            // draw
            CanvasButton(
                imageName: "pencil.and.scribble",
                isSelected: canvasModeVM.mode == .draw,
                onTap: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        canvasModeVM.mode = .draw
                        if prevColor != nil {
                            canvasVM.setColor(newColor: prevColor!)
                        }
                        if prevSize != nil {
                            canvasVM.setSize(newSize: prevSize!)
                        }
                    }
                }
            )
            // Line
            CanvasButton(
                imageName: "line.diagonal",
                isSelected: canvasModeVM.mode == .line,
                onTap: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        canvasModeVM.mode = .line
                        if prevColor != nil {
                            canvasVM.setColor(newColor: prevColor!)
                        }
                        if prevSize != nil {
                            canvasVM.setSize(newSize: prevSize!)
                        }
                    }
                }
            )
            // Rectangle
            CanvasButton(
                imageName: "rectangle",
                isSelected: canvasModeVM.mode == .rectangle,
                onTap: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        canvasModeVM.mode = .rectangle
                        if prevColor != nil {
                            canvasVM.setColor(newColor: prevColor!)
                        }
                        if prevSize != nil {
                            canvasVM.setSize(newSize: prevSize!)
                        }
                    }
                }
            )
            // erase
            CanvasButton(
                imageName: "eraser.line.dashed",
                isSelected: canvasModeVM.mode == .erase,
                onTap: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        prevSize = canvasVM.size
                        prevColor = canvasVM.color
                        canvasVM.setSize(newSize: 15.0)
                        canvasVM.setColor(newColor: ColorManager.backgroundColor)
                        canvasModeVM.mode = .erase
                    }
                }
            )
            // drag
            CanvasButton(
                imageName: "rectangle.and.hand.point.up.left.filled",
                isSelected: canvasModeVM.mode == .drag,
                onTap: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        canvasModeVM.mode = .drag
                    }
                }
            )
        }
        .padding(5)
        .background(ColorManager.lighterGrey)
        .cornerRadius(15)
    }
}

#Preview {
    DrawingToolbarView(canvasModeVM: CanvasModeViewModel(), canvasVM: CanvasItemsViewModel())
}
