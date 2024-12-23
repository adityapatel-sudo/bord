//
//  ColorPickerView.swift
//  bord
//
//  Created by Aditya Patel on 12/23/24.
//

import SwiftUI

struct ColorPickerView: View {
    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .gray, .white]
    @ObservedObject var canvas: LineViewModel

    var body: some View {
        HStack {
            HStack(spacing: 10) {
                ForEach(colors, id: \.self) { color in
                    RoundedRectangle(cornerRadius: canvas.color == color ? 5 : 8)
                        .fill(color)
                        .padding(canvas.color == color ? 5 : 0)
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                canvas.setColor(newColor: color)
                            }
                        }
                }
            }
            .padding(10)
            .background(ColorManager.lighterGrey)
            .cornerRadius(15)
            
            CustomColorPicker() { color in
                canvas.setColor(newColor: color)
            }
            .frame(width: 30, height: 30)
            .cornerRadius(5)
        }
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    static var canvas = LineViewModel()
    static var previews: some View {
        ColorPickerView(canvas: canvas)
            .preferredColorScheme(.dark)
    }
    static private func setColor(_ color: Color) -> Void {
        print("Color set to \(color)")
    }
}
