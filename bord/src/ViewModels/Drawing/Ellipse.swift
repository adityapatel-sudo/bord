//
//  Ellipse.swift
//  bord
//
//  Created by Aditya Patel on 12/31/24.
//

import SwiftUI

extension CanvasItemsViewModel {
    func newEllipse(point: CGPoint) {
        if !drawing {
            drawing = true
            currentLine = LineModel()
            lines.append(currentLine)
            currentLine.color = color
            currentLine.lineWidth = size
            currentLine.points.append(point) // Store the starting point (top-left corner of the bounding box)
        } else {
            if currentLine.points.count == 1 {
                currentLine.points.append(point) // Add the second point (current drag point)
            } else {
                currentLine.points[currentLine.points.count - 1] = point
            }
            currentLine.path = Path()

            let startPoint = currentLine.points.first!
            let endPoint = currentLine.points.last!

            let rect = CGRect(
                x: min(startPoint.x, endPoint.x),
                y: min(startPoint.y, endPoint.y),
                width: abs(endPoint.x - startPoint.x),
                height: abs(endPoint.y - startPoint.y)
            )
            currentLine.path.addEllipse(in: rect)
        }
        objectWillChange.send()
    }

    func endEllipse(point: CGPoint) {
        if currentLine.points.count > 0 {
            currentLine.points.append(point)
            currentLine.path = Path()

            let startPoint = currentLine.points.first!
            let endPoint = currentLine.points.last!

            let rect = CGRect(
                x: min(startPoint.x, endPoint.x),
                y: min(startPoint.y, endPoint.y),
                width: abs(endPoint.x - startPoint.x),
                height: abs(endPoint.y - startPoint.y)
            )
            currentLine.path.addEllipse(in: rect)

            objectWillChange.send()
        }
        drawing = false
    }
}
