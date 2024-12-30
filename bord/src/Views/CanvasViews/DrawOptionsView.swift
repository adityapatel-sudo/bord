//
//  DrawOptionsView.swift
//  bord
//
//  Created by Aditya Patel on 12/30/24.
//

import SwiftUI

struct DrawOptionsView: View {
    @ObservedObject var canvasVM: CanvasItemsViewModel

    @State var isHovered = false
    var body: some View {
        HStack(spacing: 0) {
            // plain
            Button {
                canvasVM.drawEndMode = .plain
            } label: {
                ZStack {
                    canvasVM.drawEndMode == .plain ? (
                        Image(systemName: "line.diagonal")
                            .frame(width: 50, height: 50)
                            .imageScale(.large)
                            .foregroundColor(isHovered ? .gray : .green)
                            .rotationEffect(.degrees(45))
                    ) : (
                        Image(systemName: "line.diagonal")
                            .frame(width: 50, height: 50)
                            .imageScale(.large)
                            .foregroundColor(isHovered ? .gray : .white)
                            .rotationEffect(.degrees(45))
                    )
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.green.opacity(canvasVM.drawEndMode == .plain ? 0.25 : 0))
                        .frame(width: 35, height: 35)
                }
                .onHover { hovering in
                    isHovered = hovering
                }
            }
            .buttonStyle(PlainButtonStyle())

            // arrow
            CanvasButton(
                imageName: "arrow.right",
                isSelected: canvasVM.drawEndMode == .arrow,
                onTap: {
                    canvasVM.drawEndMode = .arrow
                },
                highlightSize: 35
            )
            // arrowbothends
            CanvasButton(
                imageName: "arrow.left.and.right",
                isSelected: canvasVM.drawEndMode == .twoEndArrow,
                onTap: {
                    canvasVM.drawEndMode = .twoEndArrow
                },
                highlightSize: 35
            )
        }
        .background(ColorManager.lighterGrey)
        .cornerRadius(15)
    }
}
