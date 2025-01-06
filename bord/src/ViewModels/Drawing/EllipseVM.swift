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
            currentEllipse.addPoint(point: point)
            currentEllipse.path = Path()

            let rect = CGRect(
                x: currentEllipse.xMin,
                y: currentEllipse.yMin,
                width: (currentEllipse.xMax) - (currentEllipse.xMin),
                height: (currentEllipse.yMax) - (currentEllipse.yMin)
            )
            currentEllipse.path.addEllipse(in: rect)
        }
        objectWillChange.send()
    }

    func endEllipse(point: CGPoint) {
        drawing = false

        currentEllipse.addPoint(point: point)
        currentEllipse.path = Path()

        let rect = CGRect(
            x: currentEllipse.xMin,
            y: currentEllipse.yMin,
            width: (currentEllipse.xMax) - (currentEllipse.xMin),
            height: (currentEllipse.yMax) - (currentEllipse.yMin)
        )
        currentEllipse.path.addEllipse(in: rect)

        objectWillChange.send()
    }
}
