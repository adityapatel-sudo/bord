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
            drawn.append(currentLine)
            currentLine.path.move(to: point)
        } else {
            let prev = currentLine.points.last!
            let midPoint = DrawingUtils.getMidPoint(prev, point)
            currentLine.path.addQuadCurve(to: midPoint, control: prev)
        }
        currentLine.addPoint(point: point)
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
            drawn.append(currentLine)
            drawn.append(arrowEnd)
            currentLine.path.move(to: point)
        } else {
            let prev = currentLine.points.last!
            let midPoint = DrawingUtils.getMidPoint(prev, point)
            currentLine.path.addQuadCurve(to: midPoint, control: prev)
            arrowEnd.path = Path()
            addArrow(in: arrowEnd, from: currentLine.points[currentLine.points.count-1], to: point)
        }
        currentLine.addPoint(point: point)
        objectWillChange.send()
    }

    func endDrawnArrow() {
        drawn.removeLast()
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
            drawn.append(currentLine)
            drawn.append(arrowStart)
            drawn.append(arrowEnd)
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
        currentLine.addPoint(point: point)
        objectWillChange.send()
    }

    func endTwoDrawnArrow() {
        drawn.removeSubrange(drawn.count-2...drawn.count-1)
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
