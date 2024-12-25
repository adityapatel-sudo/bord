//
//  BottomToolbarView.swift
//  bord
//
//  Created by Aditya Patel on 12/23/24.
//

import SwiftUI

struct BottomToolbarView: View {
    @ObservedObject var canvasModeVM: CanvasModeViewModel
    @ObservedObject var lineVM: LineViewModel
    @State var prevColor: Color? = nil
    @State var clearConfirmation = false
    
    @State var hoverUndo = false
    @State var hoverReset = false

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
            
            //pan
            CanvasButton(
                imageName: "arrow.up.and.down.and.arrow.left.and.right",
                isSelected: canvasModeVM.mode == .pan,
                onTap: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        canvasModeVM.mode = .pan
                    }
                }
            )
            
            //undo
            CanvasButton(
                imageName: "arrow.uturn.backward",
                isSelected: false,
                onTap: {
                    lineVM.undo()
                }
            )

            //reset
            CanvasButton(
                imageName: "clear",
                isSelected: false,
                onTap: {
                    clearConfirmation = true
                }
            )
            .confirmationDialog("Erase all progress?", isPresented: $clearConfirmation) {
                Button("Clear", role: .destructive) { lineVM.reset() }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Do you want to reset all progress?")
            }

        }
        .padding(5)
        .background(ColorManager.lighterGrey)
        .cornerRadius(15)

    }
}

struct BottomToolbarView_Previews: PreviewProvider {
    @StateObject static var canvasModeVM = CanvasModeViewModel()
    @StateObject static var lineViewModel = LineViewModel()
    static var previews: some View {
        BottomToolbarView(canvasModeVM: canvasModeVM, lineVM: lineViewModel)
    }
}
