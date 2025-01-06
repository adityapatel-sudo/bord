//
//  ColorPickerView.swift
//  bord
//
//  Created by Aditya Patel on 12/23/24.
//

import SwiftUI

struct ColorPickerView: View {
    let colors: [Color] = [.black, ColorManager.backgroundColor, .red, .orange, .yellow, .green, .blue, .white]
    @ObservedObject var canvasVM: CanvasItemsViewModel

    var body: some View {
        HStack {
            HStack(spacing: 10) {
                ForEach(colors, id: \.self) { color in
                    RoundedRectangle(cornerRadius: canvasVM.color == color ? 5 : 8)
                        .fill(color)
                        .padding(canvasVM.color == color ? 5 : 0)
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                canvasVM.setColor(newColor: color)
                            }
                        }
                }
            }
            .padding(10)
            .background(ColorManager.lighterGrey)
            .cornerRadius(15)

            CustomColorPicker { color in
                canvasVM.setColor(newColor: color)
            }
            .frame(width: 30, height: 30)
            .cornerRadius(5)
        }
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    static var canvas = CanvasItemsViewModel()
    static var previews: some View {
        ColorPickerView(canvasVM: canvas)
            .preferredColorScheme(.dark)
    }
    static private func setColor(_ color: Color) {
        print("Color set to \(color)")
    }
}
