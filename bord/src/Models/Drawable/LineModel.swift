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
    @Published var xMin: CGFloat
    @Published var xMax: CGFloat
    @Published var yMin: CGFloat
    @Published var yMax: CGFloat

    var id: UUID = UUID()
    var lineWidth: Double
    var path: Path = Path()
    var color: Color
    var points = [CGPoint]()
    var transform: CGAffineTransform = .identity

    init(color: Color, lineWidth: Double, at startPoint: CGPoint) {
        self.color = color
        self.lineWidth = lineWidth
        self.xMin = startPoint.x
        self.xMax = startPoint.x
        self.yMin = startPoint.y
        self.yMax = startPoint.y
    }

    init(copyOf copy: LineModel) {
        self.xMin = copy.xMin + 50
        self.xMax = copy.xMax + 50
        self.yMin = copy.yMin + 50
        self.yMax = copy.yMax + 50

        self.color = copy.color
        self.lineWidth = copy.lineWidth
        self.points = copy.points.map { CGPoint(x: $0.x + 50, y: $0.y + 50) }
        self.path = copy.path.applying(CGAffineTransform(translationX: 50, y: 50))
        self.transform = copy.transform
    }

    static func == (lhs: LineModel, rhs: LineModel) -> Bool {
        lhs.id == rhs.id
    }

    func movePathBounds(by value: CGSize) {
        xMin += value.width
        xMax += value.width
        yMin += value.height
        yMax += value.height
        objectWillChange.send()
    }

    func addPoint(point: CGPoint) {
        points.append(point)
        if point.x < xMin {
            xMin = point.x
        }
        if point.x > xMax {
            xMax = point.x
        }
        if point.y < yMin {
            yMin = point.y
        }
        if point.y > yMax {
            yMax = point.y
        }
    }
}
