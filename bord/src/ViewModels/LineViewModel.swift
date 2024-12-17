//
//  CanvasData.swift
//  bord
//
//  Created by Aditya Patel on 12/16/24.
//

import Foundation

class LineViewModel: ObservableObject {
    @Published var lines: [LineModel] = []
    var currentLine = LineModel()
    var set: Bool = false;
    
    func reset() {
        lines.removeAll()
        currentLine = LineModel()
        set = false
    }
    func newPoint(point: CGPoint) {
        if (!set) {
            lines.append(currentLine)
            set = true;
        }
        currentLine.points.append(point)
        objectWillChange.send()
    }
    func lineEnded() {
        currentLine = LineModel()
        set = false
    }
    func undo() {
        if (lines.count > 0) {
            lines.removeLast()
        }
    }
}
