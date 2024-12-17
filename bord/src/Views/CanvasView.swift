//
//  CanvasView.swift
//  bord
//
//  Created by Aditya Patel on 12/15/24.
//

import SwiftUI

struct CanvasView: View {
    @ObservedObject var data: CanvasData
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
                let newPoint = value.location
                data.currentLine.points.append(newPoint)
                data.lines.append(data.currentLine)
              })
            .onEnded({ value in
                data.lines.append(data.currentLine)
                data.currentLine = Line(points: [])
            })
        )
    }
}

#Preview {
    CanvasView(data: CanvasData())
}
