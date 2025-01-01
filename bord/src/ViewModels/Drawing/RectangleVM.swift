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
            currentRect = RectangleModel(position: point, color: color, lineWidth: size)
            drawn.append(currentRect)
            currentRect.path.move(to: point)
        } else {
            let startPoint = currentRect.position
            currentRect.setDimensions(
                width: point.x - startPoint.x,
                height: point.y - startPoint.y
            )
            let rect = CGRect(
                x: min(startPoint.x, point.x),
                y: min(startPoint.y, point.y),
                width: abs(point.x - startPoint.x),
                height: abs(point.y - startPoint.y)
            )
            currentRect.path = Path()
            currentRect.endPosition = point
            let circum = rect.size.width + rect.size.height
            currentRect.path.addRoundedRect(
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
