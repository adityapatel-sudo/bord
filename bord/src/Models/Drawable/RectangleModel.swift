//
//  RectangleModel.swift
//  bord
//
//  Created by Aditya Patel on 12/31/24.
//

import Foundation
import SwiftUI

/// A model for a rectangle object
/// - Parameters:
///  - position: The top left corner position of the rectangle.
///  - width: The width of the rectangle. Can be negative if start is to the right of the end.
///  - height: The height of the rectangle. Can be negative if start is to the right of the end.
class RectangleModel: DrawableModel, ObservableObject {
    @Published var isSelected: Bool = false

    @Published var xMin: CGFloat
    @Published var xMax: CGFloat
    @Published var yMin: CGFloat
    @Published var yMax: CGFloat

    var start: CGPoint
    var end: CGPoint

    var linkedText: TextModel?

    var lineWidth: Double = 5
    var path: Path = Path()
    var id: UUID = UUID()
    var color: Color = .white
    var transform: CGAffineTransform = .identity

    static func == (lhs: RectangleModel, rhs: RectangleModel) -> Bool {
        lhs.id == rhs.id
    }

    init(position point: CGPoint) {
        xMin = point.x
        xMax = point.x
        yMin = point.y
        yMax = point.y
        start = point
        end = point
    }

    init(color: Color, lineWidth: Double, at point: CGPoint) {
        self.color = color
        self.lineWidth = lineWidth

        xMin = point.x
        xMax = point.x
        yMin = point.y
        yMax = point.y
        start = point
        end = point
    }

    init(copyOf copy: RectangleModel) {
        self.color = copy.color
        self.lineWidth = copy.lineWidth

        self.path = copy.path.applying(.init(translationX: 50, y: 50))
        self.transform = copy.transform
        self.xMax = copy.xMax + 50
        self.xMin = copy.xMin + 50
        self.yMax = copy.yMax + 50
        self.yMin = copy.yMin + 50
        self.start = copy.start.applying(.init(translationX: 50, y: 50))
        self.end = copy.end.applying(.init(translationX: 50, y: 50))
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
