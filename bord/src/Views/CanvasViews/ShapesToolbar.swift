//
//  ShapesToolbar.swift
//  bord
//
//  Created by Aditya Patel on 12/30/24.
//

import SwiftUI

struct ShapesToolbar: View {
    @ObservedObject var canvasVM: CanvasItemsViewModel
    @ObservedObject var modeVM: CanvasModeViewModel

    var body: some View {
        if modeVM.shapesEnabled {
            HStack(spacing: 0) {
                // Rectangle
                CanvasButton(
                    imageName: "rectangle",
                    isSelected: modeVM.mode == .rectangle,
                    onTap: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            modeVM.mode = .rectangle
                        }
                    }
                )
                // Line
                CanvasButton(
                    imageName: "line.diagonal",
                    isSelected: modeVM.mode == .line,
                    onTap: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            modeVM.mode = .line
                        }
                    }
                )
                // Arrow
                CanvasButton(
                    imageName: "line.diagonal.arrow",
                    isSelected: modeVM.mode == .arrow,
                    onTap: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            modeVM.mode = .arrow
                        }
                    }
                )
                // Ellipse
                CanvasButton(
                    imageName: "circle",
                    isSelected: modeVM.mode == .elipse,
                    onTap: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            modeVM.mode = .elipse
                        }
                    }
                )
            }
            .padding(5)
            .background(ColorManager.lighterGrey)
            .cornerRadius(15)

        }
    }
}
