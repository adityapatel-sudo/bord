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
    @Published var width: CGFloat = 0.0
    @Published var height: CGFloat = 0.0

    var lineWidth: Double = 5
    var path: Path = Path()
    var id: UUID = UUID()
    var color: Color = .white
    var position: CGPoint = CGPoint(x: 0, y: 0)
    var endPosition: CGPoint = CGPoint(x: 0, y: 0)

    static func == (lhs: EllipseModel, rhs: EllipseModel) -> Bool {
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

    func updatePath(with newPath: Path) {
        path = newPath
    }
}
