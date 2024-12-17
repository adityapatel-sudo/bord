//
//  CanvasData.swift
//  bord
//
//  Created by Aditya Patel on 12/16/24.
//

import Foundation

class CanvasData: ObservableObject {
    @Published var currentLine = Line()
    @Published var lines: [Line] = []
    func reset() {
        lines.removeAll()
        currentLine = Line()
    }
}
