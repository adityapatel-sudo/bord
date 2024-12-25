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
    @State var prevSize: CGFloat? = nil

    var body: some View {
        HStack(spacing: 0) {
            //draw
            CanvasButton(
                imageName: "pencil.and.scribble",
                isSelected: canvasModeVM.mode == .draw,
                onTap: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        canvasModeVM.mode = .draw
                        if ((prevColor) != nil) {
                            lineVM.setColor(newColor: prevColor!)
                        }
                        if (prevSize != nil) {
                            lineVM.setSize(newSize: prevSize!)
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
                        if ((prevColor) != nil) {
                            lineVM.setColor(newColor: prevColor!)
                        }
                        if (prevSize != nil) {
                            lineVM.setSize(newSize: prevSize!)
                        }
                    }
                }
            )
            
            //Rectangle
            CanvasButton(
                imageName: "rectangle",
                isSelected: canvasModeVM.mode == .rectangle,
                onTap: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        canvasModeVM.mode = .rectangle
                        if ((prevColor) != nil) {
                            lineVM.setColor(newColor: prevColor!)
                        }
                        if (prevSize != nil) {
                            lineVM.setSize(newSize: prevSize!)
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
                        prevSize = lineVM.size
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
