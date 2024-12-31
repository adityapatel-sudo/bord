//
//  DrawnLine.swift
//  bord
//
//  Created by Aditya Patel on 12/31/24.
//

import SwiftUI

extension CanvasItemsViewModel {
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
}
