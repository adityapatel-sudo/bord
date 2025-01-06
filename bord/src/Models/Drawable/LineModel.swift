//
//  Line.swift
//  bord/Users/adityapatel/XCodeApps/bord/bord/src/Models/LineModel.swift
//
//  Created by Aditya Patel on 12/15/24.
//

import Foundation
import SwiftUI

class LineModel: DrawableModel, ObservableObject {

    @Published var isSelected: Bool = false
    @Published var xMin: CGFloat?
    @Published var xMax: CGFloat?
    @Published var yMin: CGFloat?
    @Published var yMax: CGFloat?

    var id: UUID = UUID()
    var lineWidth: Double
    var path: Path = Path()
    var color: Color
    var points = [CGPoint]()
    var transform: CGAffineTransform = .identity

    init() {
        self.color = Color.white
        self.lineWidth = 5
    }

    init(color: Color, lineWidth: Double) {
        self.color = color
        self.lineWidth = lineWidth
    }
    static func == (lhs: LineModel, rhs: LineModel) -> Bool {
        lhs.id == rhs.id
    }
    func movePathBounds(by value: CGSize) {
        xMin! += value.width
        xMax! += value.width
        yMin! += value.height
        yMax! += value.height
    }
    func addPoint(point: CGPoint) {
        points.append(point)
        if xMin == nil || point.x < xMin! {
            xMin = point.x
        }
        if xMax == nil || point.x > xMax! {
            xMax = point.x
        }
        if yMin == nil || point.y < yMin! {
            yMin = point.y
        }
        if yMax == nil || point.y > yMax! {
            yMax = point.y
        }
    }
}
