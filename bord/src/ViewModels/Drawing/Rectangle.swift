//
//  Rectangle.swift
//  bord
//
//  Created by Aditya Patel on 12/31/24.
//

import SwiftUI

extension CanvasItemsViewModel {
    func newRectangle(point: CGPoint) {
        if !drawing {
            drawing = true
            currentLine = LineModel(color: color, lineWidth: size)
            lines.append(currentLine)
            currentLine.path.move(to: point)
            currentLine.points.append(point)
        } else {
            if currentLine.points.count == 1 {
                currentLine.points.append(point)
            } else {
                currentLine.points[currentLine.points.count - 1] = point
            }
            let startPoint = currentLine.points[0]
            let endPoint = currentLine.points[1]
            let rect = CGRect(
                x: min(startPoint.x, endPoint.x),
                y: min(startPoint.y, endPoint.y),
                width: abs(endPoint.x - startPoint.x),
                height: abs(endPoint.y - startPoint.y)
            )
            currentLine.path = Path()
            let circum = rect.size.width + rect.size.height
            currentLine.path.addRoundedRect(
                in: rect,
                cornerSize: CGSize(width: circum/100, height: circum/100)
            )
        }
        objectWillChange.send()
    }

    func endRectangle(point: CGPoint) {
        drawing = false
    }
}
