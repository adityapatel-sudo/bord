//
//  RectangleSelectView.swift
//  bord
//
//  Created by Aditya Patel on 1/10/25.
//

import SwiftUI

struct RectangleSelectView: View {
    @ObservedObject var canvasVM: CanvasItemsViewModel
    @ObservedObject var modeVM: CanvasModeViewModel
    @ObservedObject var rect: RectangleModel

    @State var changeValue: CGSize = CGSize()

    var body: some View {
        ZStack {
            whiteCircle
                .position(
                    x: rect.start.x + modeVM.currentPanOffset.width,
                    y: rect.start.y + modeVM.currentPanOffset.height
                )
                .gesture(DragGesture()
                    .onChanged { value in
                        rect.editStart(point: value.location.applying(.init(
                            translationX: -modeVM.currentPanOffset.width,
                            y: -modeVM.currentPanOffset.height
                        )))
                        rect.linkedText?.movePosition(
                            by: CGSize(width: (value.translation.width - changeValue.width)/2,
                                       height: (value.translation.height - changeValue.height)/2)
                        )
                        changeValue = value.translation
                        canvasVM.updateSelectedSizeAndPos()
                        canvasVM.objectWillChange.send()
                    }
                    .onEnded { _ in changeValue = CGSize() }
                )
            whiteCircle
                .position(
                    x: rect.end.x + modeVM.currentPanOffset.width,
                    y: rect.end.y + modeVM.currentPanOffset.height
                )
                .gesture(DragGesture()
                    .onChanged { value in
                        rect.editEnd(point: value.location.applying(.init(
                            translationX: -modeVM.currentPanOffset.width,
                            y: -modeVM.currentPanOffset.height
                        )))
                        rect.linkedText?.movePosition(
                            by: CGSize(width: (value.translation.width - changeValue.width)/2,
                                       height: (value.translation.height - changeValue.height)/2)
                        )
                        changeValue = value.translation
                        canvasVM.updateSelectedSizeAndPos()
                        canvasVM.objectWillChange.send()
                    }
                    .onEnded { _ in changeValue = CGSize() }
                )
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
                        canvasVM.remove(drawable: rect)
                    },
                    imageSize: .medium,
                    imageFrameSize: 40
                )
            }
            .background(ColorManager.lighterGrey)
            .cornerRadius(10)
            .padding(5)
            .position(
                x: (rect.start.x + rect.end.x)/2 + modeVM.currentPanOffset.width,
                y: (rect.yMin) + modeVM.currentPanOffset.height - 35
            )
        }

    }
    
    var whiteCircle: some View {
            Circle()
                .fill(Color.white)
                .frame(width: 10, height: 10)
        }
}
