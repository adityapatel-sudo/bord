//
//  ColorPickerView.swift
//  bord
//
//  Created by Aditya Patel on 12/23/24.
//

import SwiftUI

struct ColorPickerView: View {
    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .gray, .white]
    let setColor: (Color) -> Void
    @State private var selectedColor: Color? = nil

    var body: some View {
        VStack {
            HStack(spacing: 10) {
                ForEach(colors, id: \.self) { color in
                    RoundedRectangle(cornerRadius: selectedColor == color ? 5 : 10)
                        .fill(color)
                        .padding(selectedColor == color ? 10 : 0)
                        .frame(width: 40, height: 40)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedColor = color
                                setColor(color)
                            }
                        }
                }
            }
            .padding(10)
            .background(ColorManager.lighterGrey)
            .cornerRadius(15)
        }
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView(setColor: setColor)
            .preferredColorScheme(.dark)
    }
    static private func setColor(_ color: Color) -> Void {
        print("Color set to \(color)")
    }
}
