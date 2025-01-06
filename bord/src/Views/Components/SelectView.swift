//
//  SelectView.swift
//  bord
//
//  Created by Aditya Patel on 1/2/25.
//

import SwiftUI

struct SelectView: View {
    @ObservedObject var canvasVM: CanvasItemsViewModel
    @ObservedObject var modeVM: CanvasModeViewModel

    var body: some View {
        var selected = canvasVM.drawn.filter { $0.isSelected }
        if selected.count > 0 {
            VStack {
                HStack {
                    whiteCircle
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let amount = canvasVM.selectedPos.x - value.location.x
                                    for index in selected.indices {
                                        canvasVM.transformPath(&selected[index], amount: amount)
                                    }
                                    canvasVM.updateSelectedSizeAndPos()
                                }
                        )
                    Spacer()
                    ZStack {
                        whiteCircle
                            .overlay {
                                HStack(spacing: 0) {
                                    CanvasButton( // copy paste
                                        imageName: "doc.on.doc",
                                        isSelected: false,
                                        onTap: { canvasVM.duplicateSelected() },
                                        imageSize: .medium,
                                        imageFrameSize: 40
                                    )
                                    CanvasButton(
                                        imageName: "clear",
                                        isSelected: false,
                                        onTap: {
                                            for item in selected {
                                                canvasVM.remove(drawable: item)
                                            }
                                        },
                                        imageSize: .medium,
                                        imageFrameSize: 40
                                    )
                                }
                                .background(ColorManager.lighterGrey)
                                .cornerRadius(10)
                                .padding(5)
                                .offset(y: -25)
                            }
                    }
                    Spacer()
                    whiteCircle
                }
                Spacer()
                HStack {
                    whiteCircle
                    Spacer()
                    whiteCircle
                }
                Spacer()
                HStack {
                    whiteCircle
                    Spacer()
                    whiteCircle
                    Spacer()
                    whiteCircle
                }
            }
            .frame(
                width: canvasVM.selectedSize.width + 75,
                height: canvasVM.selectedSize.height + 75
            )
            .position(
                x: 0.5 * canvasVM.selectedSize.width + canvasVM.selectedPos.x + modeVM.currentPanOffset.width,
                y: 0.5 * canvasVM.selectedSize.height + canvasVM.selectedPos.y + modeVM.currentPanOffset.height
            )
            .onAppear {
                canvasVM.updateSelectedSizeAndPos()
            }
        }
    }

    var whiteCircle: some View {
            Circle()
                .fill(Color.white)
                .frame(width: 10, height: 10)
        }
}
