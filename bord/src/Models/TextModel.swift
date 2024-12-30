//
//  TextModel.swift
//  bord
//
//  Created by Aditya Patel on 12/29/24.
//

import Foundation
import SwiftUI

class TextModel: CanvasItemModel, ObservableObject {
    @Published var text: String
    @Published var width: CGFloat = 100
    var position: CGPoint
    var fontSize: CGFloat = 25
    var rotation: Double = 0

    init(text: String, position: CGPoint, color: Color) {
        self.text = text
        self.position = position
        super.init(color: color)
    }

    func increaseSize() {
        fontSize += 5
        objectWillChange.send()
    }

    func decreaseSize() {
        fontSize -= 5
        objectWillChange.send()
    }
    
    func movePosition(by translation: CGSize) {
        position.x += translation.width
        position.y += translation.height
        objectWillChange.send()
    }
}
