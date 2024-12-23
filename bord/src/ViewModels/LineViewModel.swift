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
    var size: Double = 2.0
    
    func setColor(newColor: Color) {
        color = newColor
    }
    
    func setSize(newSize: Double) {
        size = newSize
    }
    
    func reset() {
        lines.removeAll()
        currentLine = LineModel()
    }
    
    func newPoint(point: CGPoint) {
        if (currentLine.points.isEmpty) {
            lines.append(currentLine)
            currentLine.path.move(to: point)
            currentLine.color = color
            currentLine.lineWidth = size
        } else {
            let prev = currentLine.points.last
            let midPoint = CGPoint(
                x: (prev!.x + point.x) / 2,
                y: (prev!.y + point.y) / 2
            )
            currentLine.path.addQuadCurve(to: midPoint, control: prev!)
        }
        currentLine.points.append(point)
        objectWillChange.send()
    }
    func lineEnded() {
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
    func undo() {
        if (lines.count > 0) {
            lines.removeLast()
        }
    }
}
