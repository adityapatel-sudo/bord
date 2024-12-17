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
    var currentLine = LineModel()
    
    func reset() {
        lines.removeAll()
        currentLine = LineModel()
    }
    
    func newPoint(point: CGPoint) {
        if (currentLine.points.isEmpty) {
            lines.append(currentLine)
            currentLine.path.move(to: point)
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
    func getPath(line: LineModel) -> Path {
        var path = Path()
        if line.points.isEmpty {
            return path
        }
        for index in 1..<line.points.count {
            let previousPoint = line.points[index - 1]
            let currentPoint = line.points[index]
            let midPoint = CGPoint(
                x: (previousPoint.x + currentPoint.x) / 2,
                y: (previousPoint.y + currentPoint.y) / 2
            )
            if index == 1 {
                path.move(to: previousPoint)
            }
            path.addQuadCurve(to: midPoint, control: previousPoint)
            if index == line.points.count - 1 {
                path.addQuadCurve(to: currentPoint, control: midPoint)
            }
        }
        return path
    }
    func undo() {
        if (lines.count > 0) {
            lines.removeLast()
        }
    }
}
