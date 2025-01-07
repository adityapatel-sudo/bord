//
//  SizePickerView.swift
//  bord
//
//  Created by Aditya Patel on 12/25/24.
//

import SwiftUI

struct SizePickerView: View {
    @ObservedObject var canvasVM: CanvasItemsViewModel
    @State private var sliderVisible: Bool = false
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                // small
                CanvasButton(
                    imageName: "circle.fill",
                    isSelected: canvasVM.thickness == 1.5,
                    onTap: {
                        canvasVM.setSize(newSize: 1.5)
                    },
                    imageSize: .small,
                    highlightSize: 35
                )
                // medium
                CanvasButton(
                    imageName: "circle.fill",
                    isSelected: canvasVM.thickness == 4,
                    onTap: {
                        canvasVM.setSize(newSize: 4)
                    },
                    imageSize: .medium,
                    highlightSize: 35
                )
                // large
                CanvasButton(
                    imageName: "circle.fill",
                    isSelected: canvasVM.thickness == 15,
                    onTap: {
                        canvasVM.setSize(newSize: 15)
                    },
                    imageSize: .large,
                    highlightSize: 35
                )
                // slider
                CanvasButton(
                    imageName: "slider.horizontal.3",
                    isSelected: sliderVisible,
                    onTap: {sliderVisible.toggle()}
                )
            }
            .background(ColorManager.lighterGrey)
            .cornerRadius(15)

            if sliderVisible {
                Slider(value: $canvasVM.thickness, in: 1...30, step: 1)
                    .padding()
                    .frame(width: 200)
                    .background(Color.black.cornerRadius(10))
                    .shadow(radius: 5)
            }
        }
    }
}

#Preview {
    SizePickerView(canvasVM: CanvasItemsViewModel())
}
