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
    @Published var points = [CGPoint]()
    var color: Color = .red
    var lineWidth: Double = 1.0
}
