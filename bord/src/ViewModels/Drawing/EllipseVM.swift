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
            currentEllipse = EllipseModel(position: point, color: color, lineWidth: size)
            drawn.append(currentEllipse)
        } else {
            currentEllipse.endPosition = point
            currentEllipse.path = Path()

            let rect = CGRect(
                x: min(currentEllipse.position.x, currentEllipse.endPosition.x),
                y: min(currentEllipse.position.y, currentEllipse.endPosition.y),
                width: abs(currentEllipse.endPosition.x - currentEllipse.position.x),
                height: abs(currentEllipse.endPosition.y - currentEllipse.position.y)
            )

            currentEllipse.setDimensions(
                width: currentEllipse.endPosition.x - currentEllipse.position.x,
                height: currentEllipse.endPosition.y - currentEllipse.position.y
            )
            currentEllipse.path.addEllipse(in: rect)
        }
        objectWillChange.send()
    }

    func endEllipse(point: CGPoint) {
        drawing = false

        currentEllipse.endPosition = point
        currentEllipse.path = Path()

        let rect = CGRect(
            x: min(currentEllipse.position.x, currentEllipse.endPosition.x),
            y: min(currentEllipse.position.y, currentEllipse.endPosition.y),
            width: abs(currentEllipse.endPosition.x - currentEllipse.position.x),
            height: abs(currentEllipse.endPosition.y - currentEllipse.position.y)
        )
        currentEllipse.path.addEllipse(in: rect)

        objectWillChange.send()
    }
}
