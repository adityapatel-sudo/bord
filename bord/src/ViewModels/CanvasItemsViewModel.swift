//
//  CanvasData.swift
//  bord
//
//  Created by Aditya Patel on 12/16/24.
//

import Foundation
import SwiftUI

class CanvasItemsViewModel: ObservableObject {
    @Published var lines: [LineModel] = []
    @Published var texts: [TextModel] = []
    @Published var zoomScale: CGFloat = 1.0

    @Published var selectedPath: CanvasItemModel?
    @Published var isMoving = false
    @Published var currentMoveOffset: CGPoint = .zero

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
        currentLine = LineModel()
    }
    
    func remove(line: LineModel) {
        if let index = lines.firstIndex(of: line) {
            lines.remove(at: index)
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
            currentLine = LineModel()
            lines.append(currentLine)
            currentLine.path.move(to: point)
            currentLine.color = color
            currentLine.lineWidth = size
        } else {
            let prev = currentLine.points.last!
            let midPoint = CGPoint(
                x: (prev.x + point.x) / 2,
                y: (prev.y + point.y) / 2
            )
            currentLine.path.addQuadCurve(to: midPoint, control: prev)
        }
        currentLine.points.append(point)
        objectWillChange.send()
    }

    func endDraw() {
        if currentLine.points.count > 1 {
            let prev = currentLine.points[currentLine.points.count - 2]
            let cur = currentLine.points.last!
            let midPoint = CGPoint(
                x: (prev.x + cur.x) / 2,
                y: (prev.y + cur.y) / 2
            )
            currentLine.path.addQuadCurve(to: cur, control: midPoint)
            objectWillChange.send()
        } else if currentLine.points.count == 1 {
            currentLine.path.addLine(to: currentLine.points.last!)
            objectWillChange.send()
        }
        drawing = false
    }

    func newLine(point: CGPoint) {
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

    func newText(at point: CGPoint) {
        let text = TextModel(text: "Text", position: point)
        texts.append(text)
    }

    func undo() {
        if lines.count > 0 {
            lines.removeLast()
        }
    }
}
