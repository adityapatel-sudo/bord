//
//  Line.swift
//  bord/Users/adityapatel/XCodeApps/bord/bord/src/Models/LineModel.swift
//
//  Created by Aditya Patel on 12/15/24.
//

import Foundation
import SwiftUI

class LineModel: CanvasItemModel {
    var points = [CGPoint]()
    var path = Path()
    var lineWidth: Double = 1.0
}
