//
//  StraightLine.swift
//  bord
//
//  Created by Aditya Patel on 12/31/24.
//

import SwiftUI

extension CanvasItemsViewModel {
    func newLine(point: CGPoint) {
        if !drawing {
            drawing = true
            currentLine = LineModel(color: color, lineWidth: size)
            drawn.append(currentLine)
            currentLine.path.move(to: point)
            currentLine.points.append(point)
        } else {
            if currentLine.points.count == 1 {
                currentLine.points.append(point)
            } else {
                currentLine.points[currentLine.points.count - 1] = point
            }
            currentLine.path = Path()
            currentLine.path.move(to: currentLine.points.first!)
            currentLine.path.addLine(to: currentLine.points.last!)
        }
        objectWillChange.send()
    }

    func endLine(point: CGPoint) {
        if currentLine.points.count > 0 {
            currentLine.path.addLine(to: point)
            objectWillChange.send()
        }
        drawing = false
    }

    /// Adds an arrow to the current line, pointing from the start to the end. This is a STRAIGHT line.
    func newArrow(point: CGPoint) {
        if !drawing {
            drawing = true
            currentLine = LineModel()
            drawn.append(currentLine)
            currentLine.path.move(to: point)
            currentLine.color = color
            currentLine.lineWidth = size
            currentLine.points.append(point)
        } else {
            if currentLine.points.count == 1 {
                currentLine.points.append(point)
            } else {
                currentLine.points[currentLine.points.count - 1] = point
            }
            currentLine.path = Path()
            let startPoint = currentLine.points.first!
            let endPoint = currentLine.points.last!

            // Draw the main line
            currentLine.path.move(to: startPoint)
            currentLine.path.addLine(to: endPoint)

            // Add the arrowhead
            let arrowLength: CGFloat = 15.0
            let arrowAngle: CGFloat = .pi / 6 // 30 degrees

            let angle = atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x)
            let arrowPoint1 = CGPoint(
                x: endPoint.x - arrowLength * cos(angle - arrowAngle),
                y: endPoint.y - arrowLength * sin(angle - arrowAngle)
            )
            let arrowPoint2 = CGPoint(
                x: endPoint.x - arrowLength * cos(angle + arrowAngle),
                y: endPoint.y - arrowLength * sin(angle + arrowAngle)
            )

            currentLine.path.move(to: endPoint)
            currentLine.path.addLine(to: arrowPoint1)
            currentLine.path.move(to: endPoint)
            currentLine.path.addLine(to: arrowPoint2)
        }
        objectWillChange.send()
    }

    func endArrow(point: CGPoint) {
        if currentLine.points.count > 0 {
            currentLine.points.append(point)
            currentLine.path = Path()

            let startPoint = currentLine.points.first!
            let endPoint = currentLine.points.last!
            // Draw the main line
            currentLine.path.move(to: startPoint)
            currentLine.path.addLine(to: endPoint)
            // Add the arrowhead
            let arrowLength: CGFloat = 15.0
            let arrowAngle: CGFloat = .pi / 6 // 30 degrees

            let angle = atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x)
            let arrowPoint1 = CGPoint(
                x: endPoint.x - arrowLength * cos(angle - arrowAngle),
                y: endPoint.y - arrowLength * sin(angle - arrowAngle)
            )
            let arrowPoint2 = CGPoint(
                x: endPoint.x - arrowLength * cos(angle + arrowAngle),
                y: endPoint.y - arrowLength * sin(angle + arrowAngle)
            )

            currentLine.path.move(to: endPoint)
            currentLine.path.addLine(to: arrowPoint1)
            currentLine.path.move(to: endPoint)
            currentLine.path.addLine(to: arrowPoint2)

            objectWillChange.send()
        }
        drawing = false
    }
}
