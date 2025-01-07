//
//  TextModel.swift
//  bord
//
//  Created by Aditya Patel on 12/29/24.
//

import Foundation
import SwiftUI

class TextModel: CanvasItem, ObservableObject {
    var id: UUID = UUID()
    var color: Color
    @Published var text: String
    @Published var width: CGFloat = 150
    @Published var height: CGFloat = 100
    @Published var isFocused: Bool = false
    @Published var textAlignment: TextAlignment = .center

    var position: CGPoint

    var fontSize: CGFloat = 25
    var rotation: Double = 0
    var isItalics: Bool = false
    var isBold: Bool = false

    init(text: String, color: Color, position: CGPoint) {
        self.text = text
        self.color = color
        self.position = position
    }

    init(copyOf textModel: TextModel) {
        self.text = textModel.text
        self.color = textModel.color
        self.position = textModel.position.applying(CGAffineTransform(translationX: 50, y: 50))
        self.fontSize = textModel.fontSize
        self.rotation = textModel.rotation
        self.width = textModel.width
        self.height = textModel.height
    }

    static func == (lhs: TextModel, rhs: TextModel) -> Bool {
        return lhs.id == rhs.id
    }

    func increaseSize() {
        fontSize += 5
        objectWillChange.send()
    }

    func decreaseSize() {
        fontSize -= 5
        objectWillChange.send()
    }

    func setColor(to color: Color) {
        self.color = color
        objectWillChange.send()
    }

    func rotateLeft() {
        self.rotation -= 45
        objectWillChange.send()
    }

    func rotateRight() {
        self.rotation += 45
        objectWillChange.send()
    }

    func setTextAlignment(to new: TextAlignment) {
        self.textAlignment = new
        objectWillChange.send()
    }

    func movePosition(by translation: CGSize) {
        position.x += translation.width
        position.y += translation.height
        objectWillChange.send()
    }
}
