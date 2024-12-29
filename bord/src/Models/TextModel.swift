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

    init(text: String, position: CGPoint) {
        self.text = text
        self.position = position
        super.init()
    }
}
