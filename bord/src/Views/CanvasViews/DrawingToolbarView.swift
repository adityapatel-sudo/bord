//
//  DrawingToolbarView.swift
//  bord
//
//  Created by Aditya Patel on 12/25/24.
//

import SwiftUI

struct DrawingToolbarView: View {
    @ObservedObject var canvasModeVM: CanvasModeViewModel
    @ObservedObject var lineVM: LineViewModel
    @State var prevColor: Color? = nil

    var body: some View {
        HStack(spacing: 0) {
            //draw
            CanvasButton(
                imageName: "pencil.and.scribble",
                isSelected: canvasModeVM.mode == .draw,
                onTap: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        canvasModeVM.mode = .draw
                        lineVM.setSize(newSize: 2)
                        if ((prevColor) != nil) {
                            lineVM.setColor(newColor: prevColor!)
                        }
                    }
                }
            )
            
            //Line
            CanvasButton(
                imageName: "line.diagonal",
                isSelected: canvasModeVM.mode == .line,
                onTap: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        canvasModeVM.mode = .line
                        lineVM.setSize(newSize: 2)
                        if ((prevColor) != nil) {
                            lineVM.setColor(newColor: prevColor!)
                        }
                    }
                }
            )
            
            //erase
            CanvasButton(
                imageName: "eraser.line.dashed",
                isSelected: canvasModeVM.mode == .erase,
                onTap: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        prevColor = lineVM.color
                        lineVM.setSize(newSize: 15.0)
                        lineVM.setColor(newColor: ColorManager.backgroundColor)
                        canvasModeVM.mode = .erase
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
    DrawingToolbarView(canvasModeVM: CanvasModeViewModel(), lineVM: LineViewModel())
}
