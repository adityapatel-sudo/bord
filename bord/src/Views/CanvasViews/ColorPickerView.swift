//
//  ColorPickerView.swift
//  bord
//
//  Created by Aditya Patel on 12/23/24.
//

import SwiftUI

struct ColorPickerView: View {
    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .gray, .white]
    @ObservedObject var lineViewModel: LineViewModel

    var body: some View {
        HStack {
            HStack(spacing: 10) {
                ForEach(colors, id: \.self) { color in
                    RoundedRectangle(cornerRadius: lineViewModel.color == color ? 5 : 8)
                        .fill(color)
                        .padding(lineViewModel.color == color ? 5 : 0)
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                lineViewModel.setColor(newColor: color)
                            }
                        }
                }
            }
            .padding(10)
            .background(ColorManager.lighterGrey)
            .cornerRadius(15)
            
            CustomColorPicker() { color in
                lineViewModel.setColor(newColor: color)
            }
            .frame(width: 30, height: 30)
            .cornerRadius(5)
        }
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    static var canvas = LineViewModel()
    static var previews: some View {
        ColorPickerView(lineViewModel: canvas)
            .preferredColorScheme(.dark)
    }
    static private func setColor(_ color: Color) -> Void {
        print("Color set to \(color)")
    }
}
