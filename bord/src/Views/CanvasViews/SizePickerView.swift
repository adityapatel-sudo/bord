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
            if sliderVisible {
                Slider(value: $canvasVM.size, in: 1...15, step: 0.5)
                    .padding()
                    .frame(width: 200)
                    .background(Color.black.opacity(0.8).cornerRadius(10))
                    .shadow(radius: 5)
                    .transition(.opacity)
                    .animation(.easeInOut, value: sliderVisible)
            }

            HStack(spacing: 0) {
                // small
                CanvasButton(
                    imageName: "circle.fill",
                    isSelected: canvasVM.size == 1.5,
                    onTap: {
                        canvasVM.setSize(newSize: 1.5)
                    },
                    imageSize: .small
                )
                // medium
                CanvasButton(
                    imageName: "circle.fill",
                    isSelected: canvasVM.size == 4,
                    onTap: {
                        canvasVM.setSize(newSize: 4)
                    },
                    imageSize: .medium
                )
                // large
                CanvasButton(
                    imageName: "circle.fill",
                    isSelected: canvasVM.size == 8,
                    onTap: {
                        canvasVM.setSize(newSize: 8)
                    },
                    imageSize: .large
                )
                // slider
                CanvasButton(
                    imageName: "slider.horizontal.3",
                    isSelected: sliderVisible,
                    onTap: {sliderVisible.toggle()}
                )
            }
            .padding(5)
            .background(ColorManager.lighterGrey)
            .cornerRadius(15)

        }
    }
}

#Preview {
    SizePickerView(canvasVM: CanvasItemsViewModel())
}
