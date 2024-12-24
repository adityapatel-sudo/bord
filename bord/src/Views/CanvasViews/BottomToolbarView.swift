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
            ZStack {
                Image(systemName: "pencil.and.scribble")
                    .frame(width: 50, height: 50)
                    .imageScale(.large)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.orange.opacity(canvasModeVM.mode == .draw ? 0.25 : 0))
                    .frame(width: 40, height: 40)
                   
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    canvasModeVM.mode = .draw
                    lineVM.setSize(newSize: 2)
                    if ((prevColor) != nil) {
                        lineVM.setColor(newColor: prevColor!)
                    }
                }
            }
            
            //erase
            ZStack {
                Image(systemName: "eraser.line.dashed")
                    .frame(width: 50, height: 50)
                    .imageScale(.large)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.orange.opacity(canvasModeVM.mode == .erase ? 0.25 : 0))
                    .frame(width: 40, height: 40)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    prevColor = lineVM.color
                    lineVM.setSize(newSize: 15.0)
                    lineVM.setColor(newColor: ColorManager.backgroundColor)
                    canvasModeVM.mode = .erase
                }
            }
            
            //pan
            ZStack {
                Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                    .frame(width: 50, height: 50)
                    .imageScale(.large)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.orange.opacity(canvasModeVM.mode == .pan ? 0.25 : 0))
                    .frame(width: 40, height: 40)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    canvasModeVM.mode = .pan
                }
            }
            
            //undo
            ZStack {
                Image(systemName: "arrow.uturn.backward")
                    .frame(width: 50, height: 50)
                    .imageScale(.large)
                    .foregroundColor(hoverUndo ? .gray : .white)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.orange.opacity(0))
                    .frame(width: 40, height: 40)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                lineVM.undo()
            }
            .onHover { hovering in
                hoverUndo = hovering
            }
            
            
            //reset
            ZStack {
                Image(systemName: "clear")
                    .frame(width: 50, height: 50)
                    .imageScale(.large)
                    .foregroundColor(hoverReset ? .gray : .white)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.orange.opacity(0))
                    .frame(width: 40, height: 40)

            }
            .contentShape(Rectangle())
            .onTapGesture {
                clearConfirmation = true
            }
            .onHover(perform: { hovering in
                hoverReset = hovering
            })
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
