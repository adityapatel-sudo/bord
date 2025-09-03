//
//  ClipboardImageModel.swift
//  bord
//
//  Created by Aditya Patel on 4/3/25.
//

import Foundation
import SwiftUI

struct ClipboardImageModel: Identifiable {
    let id = UUID()
    var image: NSImage
    var position: CGSize = .zero
    var scale: CGFloat = 1.0
}
