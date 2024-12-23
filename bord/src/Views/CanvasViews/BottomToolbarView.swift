//
//  BottomToolbarView.swift
//  bord
//
//  Created by Aditya Patel on 12/23/24.
//

import SwiftUI

struct BottomToolbarView: View {
    @ObservedObject var mode: CanvasModeViewModel
    @ObservedObject var canvas: LineViewModel
    @State var prevColor: Color? = nil
    @State var clearConfirmation = false
    var body: some View {
        HStack(spacing: 0) {
            //draw
            ZStack {
                Image(systemName: "pencil.and.scribble")
                    .frame(width: 55, height: 55)
                    .imageScale(.large)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.orange.opacity(mode.mode == .draw ? 0.25 : 0))
                    .frame(width: 45, height: 45)
                   
            }
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    mode.mode = .draw
                    canvas.setSize(newSize: 2)
                    if ((prevColor) != nil) {
                        canvas.color = prevColor!
                    }
                }
            }
            
            //erase
            ZStack {
                Image(systemName: "eraser.line.dashed")
                    .frame(width: 55, height: 55)
                    .imageScale(.large)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.orange.opacity(mode.mode == .erase ? 0.25 : 0))
                    .frame(width: 45, height: 45)
            }
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    prevColor = canvas.color
                    canvas.setSize(newSize: 15.0)
                    canvas.setColor(newColor: ColorManager.backgroundColor)
                    mode.mode = .erase
                }
            }
            
            //pan
            ZStack {
                Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                    .frame(width: 55, height: 55)
                    .imageScale(.large)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.orange.opacity(mode.mode == .pan ? 0.25 : 0))
                    .frame(width: 45, height: 45)
            }
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    mode.mode = .pan
                }
            }
            
            //undo
            ZStack {
                Image(systemName: "arrow.uturn.backward")
                    .frame(width: 55, height: 55)
                    .imageScale(.large)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.orange.opacity(0))
                    .frame(width: 45, height: 45)
            }
            .onTapGesture {
                canvas.undo()
            }
            
            //reset
            ZStack {
                Image(systemName: "clear")
                    .frame(width: 55, height: 55)
                    .imageScale(.large)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.orange.opacity(0))
                    .frame(width: 45, height: 45)

            }
            .onTapGesture {
                clearConfirmation = true
            }
            .confirmationDialog("Erase all progress?", isPresented: $clearConfirmation) {
                Button("Clear", role: .destructive) { canvas.reset() }
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
    @StateObject static var mode = CanvasModeViewModel()
    @StateObject static var canvas = LineViewModel()
    static var previews: some View {
        BottomToolbarView(mode: mode, canvas: canvas)
    }
}
