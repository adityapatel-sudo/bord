//
//  CanvasView.swift
//  bord
//
//  Created by Aditya Patel on 12/15/24.
//

import SwiftUI

struct CanvasView: View {
    @ObservedObject var lineVM: LineViewModel
    @ObservedObject var modeVM: CanvasModeViewModel
    
    @State private var currentPanOffset: CGSize = .zero
    @State private var panOffset: CGSize = .zero
    
    var body: some View {
        Canvas { context, size in
            context.translateBy(x: currentPanOffset.width, y: currentPanOffset.height)
            for line in lineVM.lines {
                let strokeStyle = StrokeStyle(lineWidth: line.lineWidth, lineCap: .round)
                context.stroke(
                    line.path,
                    with: .color(line.color),
                    style: strokeStyle
                )
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged(handleDragChanged)
                .onEnded(handleDragEnded)
        )
    }
    private func handleDragChanged(_ value: DragGesture.Value) {
        if modeVM.mode == .draw || modeVM.mode == .erase{
            let offsetPoint = CGPoint(
                    x: value.location.x - currentPanOffset.width,
                    y: value.location.y - currentPanOffset.height
                )
            lineVM.newPoint(point: offsetPoint)
        } else if modeVM.mode == .pan {
            currentPanOffset.width = panOffset.width + value.translation.width
            currentPanOffset.height = panOffset.height + value.translation.height
        }

    }
    private func handleDragEnded(_ value: DragGesture.Value) {
        if modeVM.mode == .draw || modeVM.mode == .erase {
            lineVM.lineEnded()
        } else if modeVM.mode == .pan {
            panOffset.width += value.translation.width
            panOffset.height += value.translation.height
        }
    }
    private func handleScroll(delta: CGSize) {
        currentPanOffset.width += delta.width
        currentPanOffset.height += delta.height
        print("Scrolling handling")
    }
}

#Preview {
    CanvasView(lineVM: LineViewModel(), modeVM: CanvasModeViewModel())
}
