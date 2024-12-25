//
//  CanvasData.swift
//  bord
//
//  Created by Aditya Patel on 12/16/24.
//

import Foundation
import SwiftUI

class CanvasItemsViewModel: ObservableObject {
    @Published var items: [CanvasItemModel] = []
    @Published var zoomScale: CGFloat = 1.0
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
        items.removeAll()
        currentLine = LineModel()
    }
    
    func newDraw(point: CGPoint) {
        if (!drawing) {
            drawing = true
            currentLine = LineModel()
            items.append(currentLine)
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
        if (!drawing) {
            drawing = true
            currentLine = LineModel()
            items.append(currentLine)
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
        if (!drawing) {
            drawing = true
            currentLine = LineModel()
            items.append(currentLine)
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
            currentLine.path.addRoundedRect(
                in: rect,
                cornerSize: CGSize(width: 5, height: 5)
            )
        }
        objectWillChange.send()

    }
    
    func endRectangle(point: CGPoint) {
        drawing = false
    }

    func undo() {
        if (items.count > 0) {
            items.removeAll()
        }
    }
}
