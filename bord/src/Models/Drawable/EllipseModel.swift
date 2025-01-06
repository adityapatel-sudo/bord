//
//  EllipseModel.swift
//  bord
//
//  Created by Aditya Patel on 1/1/25.
//

import Foundation
import SwiftUI

class EllipseModel: DrawableModel, ObservableObject {
    @Published var isSelected: Bool = false

    @Published var xMin: CGFloat
    @Published var xMax: CGFloat
    @Published var yMin: CGFloat
    @Published var yMax: CGFloat

    var start: CGPoint
    var end: CGPoint

    var lineWidth: Double = 5
    var path: Path = Path()
    var id: UUID = UUID()
    var color: Color = .white
    var transform: CGAffineTransform = .identity

    static func == (lhs: EllipseModel, rhs: EllipseModel) -> Bool {
        lhs.id == rhs.id
    }

    init(position: CGPoint) {
        self.xMin = position.x
        self.yMin = position.y
        self.xMax = position.x
        self.yMax = position.y

        self.start = position
        self.end = position
    }

    init(position: CGPoint, color: Color, lineWidth: Double) {
        self.xMin = position.x
        self.yMin = position.y
        self.xMax = position.x
        self.yMax = position.y

        self.color = color
        self.lineWidth = lineWidth
        self.start = position
        self.end = position
    }

    init(copyOf copy: EllipseModel) {
        self.color = copy.color
        self.lineWidth = copy.lineWidth

        self.xMin = copy.xMin
        self.xMax = copy.xMax
        self.yMin = copy.yMin
        self.yMax = copy.yMax
        self.path = copy.path.applying(.init(translationX: 50, y: 50))
        self.transform = copy.transform
        self.start = copy.start
        self.end = copy.end
    }

    func movePathBounds(by value: CGSize) {
        start.x += value.width
        start.y += value.height
        end.x += value.width
        end.y += value.height

        xMin = min(start.x, end.x)
        xMax = max(start.x, end.x)
        yMin = min(start.y, end.y)
        yMax = max(start.y, end.y)
        objectWillChange.send()
    }

    func addPoint(point: CGPoint) {
        end = point
        xMin = min(start.x, end.x)
        xMax = max(start.x, end.x)
        yMin = min(start.y, end.y)
        yMax = max(start.y, end.y)
        objectWillChange.send()
    }
}
