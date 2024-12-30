//
//  GridPickerView.swift
//  bord
//
//  Created by Aditya Patel on 12/24/24.
//

import SwiftUI

struct GridPickerView: View {
    @ObservedObject var modeVM: CanvasModeViewModel
    var body: some View {
        HStack(spacing: 0) {
            // none
            CanvasButton(
                imageName: "square",
                isSelected: modeVM.gridMode == .none,
                onTap: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        modeVM.gridMode = .none
                    }
                },
                highlightSize: 35
            )
            // grid
            CanvasButton(
                imageName: "square.split.2x2",
                isSelected: modeVM.gridMode == .grid,
                onTap: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        modeVM.gridMode = .grid
                    }
                },
                highlightSize: 35
            )
            // lines
            CanvasButton(
                imageName: "square.split.1x2",
                isSelected: modeVM.gridMode == .lines,
                onTap: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        modeVM.gridMode = .lines
                    }
                },
                highlightSize: 35
            )
        }
        .background(ColorManager.lighterGrey)
        .cornerRadius(15)
    }
}

#Preview {
    GridPickerView(modeVM: CanvasModeViewModel())
}
