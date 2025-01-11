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
///  - isEllipse: A boolean value that determines if the rectangle is an ellipse or not.
///  - color: The color of the rectangle.
///  - lineWidth: The width of the stroke of the rectangle.
///
///
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
    var isEllipse: Bool

    static func == (lhs: RectangleModel, rhs: RectangleModel) -> Bool {
        lhs.id == rhs.id
    }

    init(position point: CGPoint, isEllipse: Bool = false) {
        xMin = point.x
        xMax = point.x
        yMin = point.y
        yMax = point.y
        start = point
        end = point
        self.isEllipse = isEllipse
    }

    init(color: Color, lineWidth: Double, at point: CGPoint, isEllipse: Bool = false) {
        self.color = color
        self.lineWidth = lineWidth

        xMin = point.x
        xMax = point.x
        yMin = point.y
        yMax = point.y
        start = point
        end = point

        self.isEllipse = isEllipse
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
        self.isEllipse = copy.isEllipse

        if copy.linkedText != nil {
            let copy = TextModel(copyOf: copy.linkedText!)
            self.linkedText = copy
        }
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
        path = Path()
        let rect = CGRect(
            x: xMin,
            y: yMin,
            width: xMax - xMin,
            height: yMax - yMin
        )
        let circum = rect.size.width + rect.size.height
        if isEllipse {
            path.addEllipse(in: rect)
        } else {
            path.addRoundedRect(
                in: rect,
                cornerSize: CGSize(width: circum/100, height: circum/100)
            )
        }
        objectWillChange.send()
    }

    func editEnd(point: CGPoint) {
        end = point
        xMin = min(start.x, end.x)
        xMax = max(start.x, end.x)
        yMin = min(start.y, end.y)
        yMax = max(start.y, end.y)
        path = Path()
        let rect = CGRect(
            x: xMin,
            y: yMin,
            width: xMax - xMin,
            height: yMax - yMin
        )
        let circum = rect.size.width + rect.size.height
        if isEllipse {
            path.addEllipse(in: rect)
        } else {
            path.addRoundedRect(
                in: rect,
                cornerSize: CGSize(width: circum/100, height: circum/100)
            )
        }
        objectWillChange.send()
    }

    func editStart(point: CGPoint) {
        start = point
        xMin = min(start.x, end.x)
        xMax = max(start.x, end.x)
        yMin = min(start.y, end.y)
        yMax = max(start.y, end.y)
        path = Path()
        let rect = CGRect(
            x: xMin,
            y: yMin,
            width: xMax - xMin,
            height: yMax - yMin
        )
        let circum = rect.size.width + rect.size.height
        if isEllipse {
            path.addEllipse(in: rect)
        } else {
            path.addRoundedRect(
                in: rect,
                cornerSize: CGSize(width: circum/100, height: circum/100)
            )
        }

        objectWillChange.send()
    }
}
