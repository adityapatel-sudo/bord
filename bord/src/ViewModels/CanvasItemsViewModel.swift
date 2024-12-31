//
//  CanvasData.swift
//  bord
//
//  Created by Aditya Patel on 12/16/24.
//

import Foundation
import SwiftUI

/**
    * The view model for the canvas items. This class is responsible for managing the canvas items and their properties.
 */
class CanvasItemsViewModel: ObservableObject {
    @Published var lines: [LineModel] = []
    @Published var texts: [TextModel] = []

    @Published var selectedPath: CanvasItemModel?
    @Published var isMoving = false
    @Published var currentMoveOffset: CGPoint = .zero

    // used for arrow heads while drawing
    // Line models will be saved in lines while drawing, then be combined with the drawn line on end
    @Published var drawEndMode: DrawEndMode = .plain
    var arrowStart: LineModel = LineModel()
    var arrowEnd: LineModel = LineModel()

    // new items attributes
    var color: Color = .white
    var currentLine: LineModel = LineModel()
    var size: Double = 1.5

    var drawing: Bool = false

    func setColor(newColor: Color) {
        color = newColor
        objectWillChange.send()
    }

    func setSize(newSize: Double) {
        size = newSize
        objectWillChange.send()
    }

    func reset() {
        lines.removeAll()
        texts.removeAll()
        currentLine = LineModel()
    }

    func remove(line: LineModel) {
        if let index = lines.firstIndex(of: line) {
            lines.remove(at: index)
            objectWillChange.send()
        }
    }

    func remove(text: TextModel) {
        if let index = texts.firstIndex(of: text) {
            texts.remove(at: index)
            objectWillChange.send()
        }
    }

    func moveLine(_ line: LineModel, by value: CGSize) {
        line.path = line.path.applying(.init(translationX: value.width, y: value.height))
        objectWillChange.send()
    }

    func newDraw(point: CGPoint) {
        if !drawing {
            drawing = true
            currentLine = LineModel(color: color, lineWidth: size)
            lines.append(currentLine)
            currentLine.path.move(to: point)
        } else {
            let prev = currentLine.points.last!
            let midPoint = DrawingUtils.getMidPoint(prev, point)
            currentLine.path.addQuadCurve(to: midPoint, control: prev)
        }
        currentLine.points.append(point)
        objectWillChange.send()
    }

    func endDraw() {
        if currentLine.points.count > 1 {
            let prev = currentLine.points[currentLine.points.count - 2]
            let cur = currentLine.points.last!
            let midPoint = DrawingUtils.getMidPoint(prev, cur)
            currentLine.path.addQuadCurve(to: cur, control: midPoint)
            objectWillChange.send()
        } else if currentLine.points.count == 1 {
            currentLine.path.addLine(to: currentLine.points.last!)
            objectWillChange.send()
        }
        drawing = false
    }

    func newDrawnArrow(point: CGPoint) {
        if !drawing {
            drawing = true
            currentLine = LineModel(color: color, lineWidth: size)
            arrowEnd = LineModel(color: color, lineWidth: size)
            lines.append(currentLine)
            lines.append(arrowEnd)
            currentLine.path.move(to: point)
        } else {
            let prev = currentLine.points.last!
            let midPoint = DrawingUtils.getMidPoint(prev, point)
            currentLine.path.addQuadCurve(to: midPoint, control: prev)
            arrowEnd.path = Path()
            addArrow(in: arrowEnd, from: currentLine.points[currentLine.points.count-1], to: point)
        }
        currentLine.points.append(point)
        objectWillChange.send()
    }

    func endDrawnArrow() {
        lines.removeLast()
        if currentLine.points.count > 1 {
            let prev = currentLine.points[currentLine.points.count - 2]
            let cur = currentLine.points.last!
            let midPoint = DrawingUtils.getMidPoint(prev, cur)
            currentLine.path.addQuadCurve(to: cur, control: midPoint)
            currentLine.path.addPath(arrowEnd.path)
            objectWillChange.send()
        } else if currentLine.points.count == 1 {
            currentLine.path.addLine(to: currentLine.points.last!)
            objectWillChange.send()
        }
        drawing = false
    }

    func newTwoDrawnArrow(point: CGPoint) {
        if !drawing {
            drawing = true
            currentLine = LineModel(color: color, lineWidth: size)
            arrowStart = LineModel(color: color, lineWidth: size)
            arrowEnd = LineModel(color: color, lineWidth: size)
            lines.append(currentLine)
            lines.append(arrowStart)
            lines.append(arrowEnd)
            currentLine.path.move(to: point)
        } else {
            if currentLine.points.count == 4 {
                arrowStart.path = Path()
                addArrow(in: arrowStart, from: point, to: currentLine.points[0])
            }
            let prev = currentLine.points.last!
            let midPoint = DrawingUtils.getMidPoint(prev, point)
            currentLine.path.addQuadCurve(to: midPoint, control: prev)
            arrowEnd.path = Path()
            addArrow(in: arrowEnd, from: currentLine.points[currentLine.points.count-1], to: point)
        }
        currentLine.points.append(point)
        objectWillChange.send()
    }

    func endTwoDrawnArrow() {
        lines.removeSubrange(lines.count-2...lines.count-1)
        if currentLine.points.count > 1 {
            let prev = currentLine.points[currentLine.points.count - 2]
            let cur = currentLine.points.last!
            let midPoint = DrawingUtils.getMidPoint(prev, cur)
            currentLine.path.addQuadCurve(to: cur, control: midPoint)
            currentLine.path.addPath(arrowEnd.path)
            currentLine.path.addPath(arrowStart.path)
            objectWillChange.send()
        } else if currentLine.points.count == 1 {
            currentLine.path.addLine(to: currentLine.points.last!)
            objectWillChange.send()
        }
        drawing = false
    }

    private func addArrow(in arrow: LineModel, from start: CGPoint, to end: CGPoint) {
        let arrowLength: CGFloat = 15.0
        let arrowAngle: CGFloat = .pi / 6.0

        // Calculate the direction vector
        let dx = end.x - start.x
        let dy = end.y - start.y
        let angle = atan2(dy, dx)

        // Calculate the two points for the arrowhead
        let point1 = CGPoint(
            x: end.x - arrowLength * cos(angle - arrowAngle),
            y: end.y - arrowLength * sin(angle - arrowAngle)
        )
        let point2 = CGPoint(
            x: end.x - arrowLength * cos(angle + arrowAngle),
            y: end.y - arrowLength * sin(angle + arrowAngle)
        )

        // Draw the arrowhead
        arrow.path.move(to: end)
        arrow.path.addLine(to: point1)
        arrow.path.move(to: end)
        arrow.path.addLine(to: point2)
        arrow.path.move(to: end)
    }


    func newLine(point: CGPoint) {
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

/// Adds an arrow to the current line, pointing from the start to the end. This is a STRAIGHT line.
    func newArrow(point: CGPoint) {
        if !drawing {
            drawing = true
            currentLine = LineModel()
            lines.append(currentLine)
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

    func endRectangle(point: CGPoint) {
        drawing = false
    }

    func newText(at point: CGPoint) {
        let text = TextModel(text: "", position: point, color: color)
        texts.append(text)
    }

    func undo() {
        if lines.count > 0 {
            lines.removeLast()
        }
    }
}
