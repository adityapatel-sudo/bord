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
    @Published var width: CGFloat = 0.0
    @Published var height: CGFloat = 0.0

    var lineWidth: Double = 5
    var path: Path = Path()
    var id: UUID = UUID()
    var color: Color = .white
    var position: CGPoint = CGPoint(x: 0, y: 0)
    var endPosition: CGPoint = CGPoint(x: 0, y: 0)
    var transform: CGAffineTransform = .identity

    static func == (lhs: RectangleModel, rhs: RectangleModel) -> Bool {
        lhs.id == rhs.id
    }

    init() {}

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

    func setDimensions(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
        objectWillChange.send()
    }

    func movePathBounds(by value: CGSize) {
        position.x += value.width
        position.y += value.height
        objectWillChange.send()
    }
}
