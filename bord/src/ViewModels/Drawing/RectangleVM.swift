//
//  Rectangle.swift
//  bord
//
//  Created by Aditya Patel on 12/31/24.
//

import SwiftUI

extension CanvasItemsViewModel {
    func newRectangle(point: CGPoint, isEllipse: Bool) {
        if !drawing {
            drawing = true
            currentRect = RectangleModel(color: color, lineWidth: thickness, at: point, isEllipse: isEllipse)
            drawn.append(currentRect)
            currentRect.path.move(to: point)
        } else {
            currentRect.editEnd(point: point)
        }
        objectWillChange.send()
    }

    func endRectangle(point: CGPoint) {
        drawing = false
        if isTextInShapes && currentRect.xMax - currentRect.xMin > 50  && currentRect.yMax - currentRect.yMin > 20 {
            currentRect.linkedText = TextModel(
                text: "default text",
                color: color,
                position: CGPoint(
                    x: (currentRect.xMin + currentRect.xMax)/2,
                    y: (currentRect.yMin + currentRect.yMax)/2
                )
            )
            texts.append(currentRect.linkedText!)
            currentRect.linkedText?.isFocused = true
            currentRect.linkedText?.width = currentRect.xMax - currentRect.xMin - 50
        }
        currentRect.editEnd(point: point)
        objectWillChange.send()
    }

    func changeSize(of rectangle: RectangleModel, by value: CGFloat, of side: Side) {
        switch side {
        case .top:
            rectangle.start.y += value
            rectangle.yMin += value
        case .bot:
            rectangle.end.y += value
            rectangle.yMax += value
        case .left:
            rectangle.start.x += value
            rectangle.xMin += value
        case .right:
            rectangle.end.x += value
            rectangle.xMax += value
        }
        let rect = CGRect(
            x: currentRect.xMin,
            y: currentRect.yMin,
            width: currentRect.xMax - currentRect.xMin,
            height: currentRect.yMax - currentRect.yMin
        )
        let circum = rect.size.width + rect.size.height
        currentRect.path = Path()
        if currentRect.isEllipse {
            currentRect.path.addEllipse(in: rect)
        } else {
            currentRect.path.addRoundedRect(
                in: rect,
                cornerSize: CGSize(width: circum/100, height: circum/100)
            )
        }
    }
}
