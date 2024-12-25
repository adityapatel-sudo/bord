//
//  CanvasData.swift
//  bord
//
//  Created by Aditya Patel on 12/16/24.
//

import Foundation
import SwiftUI

class LineViewModel: ObservableObject {
    @Published var lines: [LineModel] = []
    @Published var zoomScale: CGFloat = 1.0
    var color: Color = .white
    var currentLine: LineModel = LineModel()
    var size: Double = 1.5
    
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
    
    func newDraw(point: CGPoint) {
        if (currentLine.points.isEmpty) {
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
    
    func drawEnded() {
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
        currentLine = LineModel()
    }
    
    func newLine(point: CGPoint) {
        if (currentLine.points.isEmpty) {
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
        currentLine = LineModel()
    }
    
    func undo() {
        if (lines.count > 0) {
            lines.removeLast()
        }
    }
}
