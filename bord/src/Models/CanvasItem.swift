//
//  CanvasItemModel.swift
//  bord
//
//  Created by Aditya Patel on 12/25/24.
//

import Foundation
import SwiftUI

protocol CanvasItem: Identifiable, Equatable {
    var id: UUID { get set }
    var color: Color { get set }
}
