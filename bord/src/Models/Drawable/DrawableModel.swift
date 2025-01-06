//
//  DrawableModel.swift
//  bord
//
//  Created by Aditya Patel on 12/31/24.
//

import Foundation
import SwiftUI

protocol DrawableModel: CanvasItem {
    var isSelected: Bool { get set }
    var lineWidth: Double { get set }
    var path: Path { get set }
    var transform: CGAffineTransform { get set }

    var xMin: CGFloat {get set}
    var xMax: CGFloat {get set}
    var yMin: CGFloat {get set}
    var yMax: CGFloat {get set}
    func movePathBounds(by value: CGSize)
}
