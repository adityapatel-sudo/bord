//
//  CanvasView.swift
//  bord
//
//  Created by Aditya Patel on 12/15/24.
//

import SwiftUI

struct CanvasView: View {
    @ObservedObject var data: LineViewModel
    var body: some View {
        Canvas { context, size in
            for line in data.lines {
                var path = Path()
                path.addLines(line.points)
                context.stroke(path, with: .color(line.color), lineWidth: line.lineWidth)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({ value in
                data.newPoint(point: value.location)
              })
            .onEnded({ value in
                data.lineEnded()
            })
        )
    }
}

#Preview {
    CanvasView(data: LineViewModel())
}
