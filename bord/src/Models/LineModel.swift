//
//  Line.swift
//  bord
//
//  Created by Aditya Patel on 12/15/24.
//

import Foundation
import SwiftUI

class LineModel: Observable, Identifiable {
    let id = UUID()
    var points = [CGPoint]()
    var path = Path()
    var color: Color
    var lineWidth: Double = 1.0
    init () {
        self.color = .black
    }
    init(color: Color) {
        self.color = color
    }
}
