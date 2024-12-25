//
//  CanvasItemModel.swift
//  bord
//
//  Created by Aditya Patel on 12/25/24.
//

import Foundation
import SwiftUI

class CanvasItemModel: Observable, Identifiable {
    let id = UUID()
    var color: Color

    init () {
        self.color = .black
    }
    init(color: Color) {
        self.color = color
    }
}
