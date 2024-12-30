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

    var body: some View {
        HStack(spacing: 0) {
            // draw
            CanvasButton(
                imageName: "pencil.and.scribble",
                isSelected: canvasModeVM.mode == .draw,
                onTap: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        canvasModeVM.mode = .draw
                    }
                }
            )
            // erase
            CanvasButton(
                imageName: "eraser.line.dashed",
                isSelected: canvasModeVM.mode == .erase,
                onTap: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        canvasModeVM.shapesEnabled = false
                        canvasModeVM.mode = .erase
                    }
                }
            )
            // select
            CanvasButton(
                imageName: "rectangle.and.hand.point.up.left.filled",
                isSelected: canvasModeVM.mode == .select,
                onTap: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        canvasModeVM.mode = .select
                    }
                }
            )
            // text
            CanvasButton(
                imageName: "character.cursor.ibeam",
                isSelected: canvasModeVM.mode == .text,
                onTap: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        canvasModeVM.mode = .text
                    }
                }
            )
            // Shapes (line, arrow, rect, ellipse)
            CanvasButton(
                imageName: "square.on.circle",
                isSelected: canvasModeVM.shapesEnabled,
                onTap: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        canvasModeVM.shapesEnabled.toggle()
                    }
                }
            )
        }
        .padding(5)
        .background(ColorManager.lighterGrey)
        .cornerRadius(15)
        .ignoresSafeArea()
    }
}

#Preview {
    DrawingToolbarView(canvasModeVM: CanvasModeViewModel(panOffset: .zero), canvasVM: CanvasItemsViewModel())
}
