//
//  CanvasView.swift
//  bord
//
//  Created by Aditya Patel on 12/15/24.
//

import SwiftUI

struct CanvasView: View {
    @ObservedObject var data: LineViewModel
    @ObservedObject var mode: CanvasModeViewModel
    
    @State private var currentPanOffset: CGSize = .zero
    @State private var panOffset: CGSize = .zero
    
    var body: some View {
        Canvas { context, size in
            context.translateBy(x: currentPanOffset.width, y: currentPanOffset.height)
            for line in data.lines {
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
                .onChanged { value in
                    if mode.mode == .draw || mode.mode == .erase{
                        let offsetPoint = CGPoint(
                                x: value.location.x - currentPanOffset.width,
                                y: value.location.y - currentPanOffset.height
                            )
                        data.newPoint(point: offsetPoint)
                    } else if mode.mode == .pan {
                        currentPanOffset.width = panOffset.width + value.translation.width
                        currentPanOffset.height = panOffset.height + value.translation.height
                    }
                }
                .onEnded { value in
                    if mode.mode == .draw || mode.mode == .erase {
                        data.lineEnded()
                    } else if mode.mode == .pan {
                        panOffset.width += value.translation.width
                        panOffset.height += value.translation.height
                    }
                }
        )
    }
}

#Preview {
    CanvasView(data: LineViewModel(), mode: CanvasModeViewModel())
}
