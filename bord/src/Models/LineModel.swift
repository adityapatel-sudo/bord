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
    var color: Color = .white
    var lineWidth: Double = 5.0
}
