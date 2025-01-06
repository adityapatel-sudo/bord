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
    var arrowStart: LineModel = LineModel(color: .black, lineWidth: 0, at: .zero)
    var arrowEnd: LineModel = LineModel(color: .black, lineWidth: 0, at: .zero)

    // new items attributes
    var color: Color = .white
    var currentLine: LineModel = LineModel(color: .black, lineWidth: 0, at: .zero)
    var currentRect: RectangleModel = RectangleModel(position: .zero)
    var currentEllipse: EllipseModel = EllipseModel(position: .zero)
    var size: Double = 1.5

    // selected item view
    @Published var selectedSize: CGSize = .zero
    @Published var selectedPos: CGPoint = .zero

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
        currentLine = LineModel(color: .background, lineWidth: 0, at: .zero)
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
        path.path = transformedPath
        path.movePathBounds(by: .zero)
        objectWillChange.send()
    }

    func updateSelectedSizeAndPos() {
        var maxX: CGFloat?
        var minX: CGFloat?
        var maxY: CGFloat?
        var minY: CGFloat?

        for item in getSelected() {
            if let line = item as? LineModel {
                if maxX == nil || line.xMax > maxX! {
                    maxX = line.xMax
                }
                if minX == nil || line.xMin < minX! {
                    minX = line.xMin
                }
                if maxY == nil || line.yMax > maxY! {
                    maxY = line.yMax
                }
                if minY == nil || line.yMin < minY! {
                    minY = line.yMin
                }
            } else if let rect = item as? RectangleModel {
                if maxX == nil || rect.xMax > maxX! {
                    maxX = rect.xMax
                }
                if minX == nil || rect.xMin < minX! {
                    minX = rect.xMin
                }
                if maxY == nil || rect.yMax > maxY! {
                    maxY = rect.yMax
                }
                if minY == nil || rect.yMin < minY! {
                    minY = rect.yMin
                }
            } else if let circle = item as? EllipseModel {
                if maxX == nil || circle.xMax > maxX! {
                    maxX = circle.xMax
                }
                if minX == nil || circle.xMin < minX! {
                    minX = circle.xMin
                }
                if maxY == nil || circle.yMax > maxY! {
                    maxY = circle.yMax
                }
                if minY == nil || circle.yMin < minY! {
                    minY = circle.yMin
                }
            }         }
        if minX != nil && minY != nil {
            selectedPos = CGPoint(x: minX!, y: minY!)
            selectedSize = CGSize(width: maxX! - minX!, height: maxY! - minY!)
        } else {
            selectedPos = .zero
            selectedSize = .zero
        }
        objectWillChange.send()
    }

    func duplicateSelected() {
        for item in getSelected() {
            if let line = item as? LineModel {
                drawn.append(LineModel(copyOf: line))
            } else if let rectangle = item as? RectangleModel {
                drawn.append(RectangleModel(copyOf: rectangle))
            } else if let ellipse = item as? EllipseModel {
                drawn.append(EllipseModel(copyOf: ellipse))
            }
        }
    }
}
