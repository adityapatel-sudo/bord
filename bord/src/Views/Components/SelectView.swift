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

    @State var rotation = 0.0

    var body: some View {
        var selected = canvasVM.drawn.filter { $0.isSelected }
        if selected.count > 0 {
            let width = getWidth(selected)
            let height = getHeight(selected)
            VStack {
                HStack {
                    whiteCircle
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    for index in selected.indices {
                                        canvasVM.transformPath(&selected[index], amount: value.translation.width)
                                    }
                                }
                        )
                    Spacer()
                    ZStack {
                        whiteCircle
                        HStack(spacing: 0) {
                            CanvasButton( // rotate
                                imageName: "arrow.clockwise",
                                isSelected: false,
                                onTap: {},
                                imageSize: .medium,
                                imageFrameSize: 40
                            )
                            .highPriorityGesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        let difference = value.translation.width - rotation
                                        rotation = value.translation.width
                                        for index in selected.indices {
                                            let center = CGPoint(
                                                x: 0.5 * width.width + width.x,
                                                y: 0.5 * height.height + height.y
                                            )
                                            canvasVM.rotatePath(&selected[index], amount: difference, around: center)
                                        }
                                    }
                            )

                            CanvasButton( // copy paste
                                imageName: "doc.on.doc",
                                isSelected: false,
                                onTap: {
                                    
                                },
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
                        .offset(y: -50)
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
                width: width.width,
                height: height.height
            )
            .position(
                x: 0.5 * width.width + width.x + modeVM.currentPanOffset.width,
                y: 0.5 * height.height + height.y + modeVM.currentPanOffset.height
            )
        }
    }

    var whiteCircle: some View {
            Circle()
                .fill(Color.white)
                .frame(width: 10, height: 10)
        }

    func getWidth(_ selected: [any DrawableModel]) -> (width: CGFloat, x: CGFloat) {
        var maxX: CGFloat?
        var minX: CGFloat?
        for item in selected {
            if let line = item as? LineModel {
                if maxX == nil || line.xMax ?? maxX! > maxX! {
                    maxX = line.xMax
                }
                if minX == nil || line.xMin ?? minX! < minX! {
                    minX = line.xMin
                }
            }
        }
        if maxX == nil || minX == nil {
            return (0, 0)
        }
        return (maxX! - minX!, minX!)
    }
    func getHeight(_ selected: [any DrawableModel]) -> (height: CGFloat, y: CGFloat) {
        var maxY: CGFloat?
        var minY: CGFloat?
        for item in selected {
            if let line = item as? LineModel {
                if maxY == nil || line.yMax ?? maxY! > maxY! {
                    maxY = line.yMax
                }
                if minY == nil || line.yMin ?? minY! < minY! {
                    minY = line.yMin
                }
            }
        }
        if maxY == nil || minY == nil {
            return (0, 0)
        }
        return (maxY! - minY!, minY!)
    }
}
