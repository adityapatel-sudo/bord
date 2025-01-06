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
            currentRect = RectangleModel(color: color, lineWidth: size, at: point)
            drawn.append(currentRect)
            currentRect.path.move(to: point)
        } else {
            currentRect.addPoint(point: point)
            currentRect.path = Path()
            let rect = CGRect(
                x: currentRect.xMin,
                y: currentRect.yMin,
                width: currentRect.xMax - currentRect.xMin,
                height: currentRect.yMax - currentRect.yMin
            )
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
        if true {
            currentRect.linkedText = TextModel(
                text: "",
                color: color,
                position: CGPoint(x: (currentRect.xMin + currentRect.xMax)/2, y: (currentRect.yMin + currentRect.yMax)/2)
            )
            texts.append(currentRect.linkedText!)
            currentRect.linkedText?.isFocused = true
        }
        currentRect.addPoint(point: point)
        objectWillChange.send()
    }
}
