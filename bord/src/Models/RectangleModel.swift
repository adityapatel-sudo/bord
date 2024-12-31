//
//  RectangleModel.swift
//  bord
//
//  Created by Aditya Patel on 12/31/24.
//

import Foundation
import SwiftUI

class RectangleModel: DrawableModel {
    var lineWidth: Double = 5
    var path: Path = Path()
    var id: UUID = UUID()
    var color: Color = .white
    var position: CGPoint = CGPoint(x: 0, y: 0)
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0

    static func == (lhs: RectangleModel, rhs: RectangleModel) -> Bool {
        lhs.id == rhs.id
    }

    init(position: CGPoint) {
        self.position = position
    }

    init(position: CGPoint, color: Color, lineWidth: Double) {
        self.position = position
        self.color = color
        self.lineWidth = lineWidth
    }

    init(position: CGPoint, width: CGFloat, height: CGFloat, color: Color, lineWidth: Double) {
        self.position = position
        self.width = width
        self.height = height
        self.color = color
        self.lineWidth = lineWidth
    }
}
