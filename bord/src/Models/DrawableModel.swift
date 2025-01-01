//
//  DrawableModel.swift
//  bord
//
//  Created by Aditya Patel on 12/31/24.
//

import Foundation
import SwiftUI

protocol DrawableModel: CanvasItem, AnyObject {
    var isSelected: Bool { get set }
    var lineWidth: Double { get set }
    var path: Path { get set }
    var height: CGFloat { get set }
    var width: CGFloat { get set }

    func updatePath(with newPath: Path)
}
