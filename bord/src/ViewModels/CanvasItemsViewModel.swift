//
//  CanvasData.swift
//  bord
//
//  Created by Aditya Patel on 12/16/24.
//

import Foundation
import SwiftUI

/**
The view model for the canvas items. This class is responsible for managing the canvas items and their properties.
 - Parameters:
 - lines: An array of LineModel objects representing the lines on the canvas.
 */
class CanvasItemsViewModel: ObservableObject {
    @Published var drawn: [any DrawableModel] = []
    @Published var texts: [TextModel] = []

    @Published var selectedPath: (any DrawableModel)?
    @Published var isMoving = false
    @Published var currentMoveOffset: CGPoint = .zero

    // used for arrow heads while drawing
    // Line models will be saved in lines while drawing, then be combined with the drawn line on end
    @Published var drawEndMode: DrawEndMode = .plain
    var arrowStart: LineModel = LineModel()
    var arrowEnd: LineModel = LineModel()

    // new items attributes
    var color: Color = .white
    var currentLine: LineModel = LineModel()
    var currentRect: RectangleModel = RectangleModel()
    var currentEllipse: EllipseModel = EllipseModel()
    var size: Double = 1.5

    var drawing: Bool = false

    var selectedDrawnCount: Int {
        drawn.filter { $0.isSelected }.count
    }

    func setColor(newColor: Color) {
        color = newColor
        objectWillChange.send()
    }

    func setSize(newSize: Double) {
        size = newSize
        objectWillChange.send()
    }

    func reset() {
        drawn.removeAll()
        texts.removeAll()
        currentLine = LineModel()
    }

    func remove(drawable: any DrawableModel) {
        for (index, line) in drawn.enumerated() where line.id == drawable.id {
            drawn.remove(at: index)
            objectWillChange.send()
        }
    }

    func remove(text: TextModel) {
        if let index = texts.firstIndex(of: text) {
            texts.remove(at: index)
            objectWillChange.send()
        }
    }

    func moveLine(_ line: LineModel, by value: CGSize) {
        line.path = line.path.applying(.init(translationX: value.width, y: value.height))
        objectWillChange.send()
    }

    func movePath(_ path: inout any DrawableModel, by value: CGSize) {
        path.transform = path.transform.concatenating(.init(translationX: value.width, y: value.height))
        path.movePathBounds(by: value)
        objectWillChange.send()
    }

    func unselectAll() {
        for index in 0..<drawn.count where drawn[index].isSelected {
            drawn[index].isSelected = false
        }
    }

    func getSelected() -> [any DrawableModel] {
        return drawn.filter { $0.isSelected }
    }

    func addArrow(in arrow: LineModel, from start: CGPoint, to end: CGPoint) {
        let arrowLength: CGFloat = 15.0
        let arrowAngle: CGFloat = .pi / 6.0

        // Calculate the direction vector
        let angle = atan2(end.y - start.y, end.x - start.x)

        // Calculate the two points for the arrowhead
        let point1 = CGPoint(
            x: end.x - arrowLength * cos(angle - arrowAngle),
            y: end.y - arrowLength * sin(angle - arrowAngle)
        )
        let point2 = CGPoint(
            x: end.x - arrowLength * cos(angle + arrowAngle),
            y: end.y - arrowLength * sin(angle + arrowAngle)
        )

        // Draw the arrowhead
        arrow.path.move(to: end)
        arrow.path.addLine(to: point1)
        arrow.path.move(to: end)
        arrow.path.addLine(to: point2)
        arrow.path.move(to: end)
    }

    func newText(at point: CGPoint) {
        let text = TextModel(text: "", color: color, position: point)
        texts.append(text)
    }

    func undo() {
        if drawn.count > 0 {
            drawn.removeLast()
        }
    }

    func transformPath(_ path: inout any DrawableModel, amount: CGFloat) {
        var transform: CGAffineTransform
        let percentage = (amount + 500) / 500
        transform = CGAffineTransform.init(scaleX: percentage, y: 1)
        let transformedPath = path.path.applying(transform)
        path.movePathBounds(by: .zero)
        objectWillChange.send()
    }

    func rotatePath(_ path: inout any DrawableModel, amount: CGFloat, around center: CGPoint) {
        let before = path.transform
        let transform = CGAffineTransform(rotationAngle: amount * .pi / 180)
        // Create a translation transform to move the path center to the origin
        let translationToOrigin = CGAffineTransform(translationX: -center.x, y: -center.y)
        // Create a translation transform to move the path back after rotation
        let translationBack = CGAffineTransform(translationX: center.x, y: center.y)
        // Apply the transformations (translate to origin, rotate, and translate back)
        let finalTransform = before
            .concatenating(translationToOrigin)
            .concatenating(transform)
            .concatenating(translationBack)
        path.transform = finalTransform
        objectWillChange.send()
    }
}
