//
//  DrawingUtils.swift
//  bord
//
//  Created by Aditya Patel on 12/31/24.
//

import SwiftUI

struct DrawingUtils {
    static func getMidPoint(_ prev: CGPoint, _ cur: CGPoint) -> CGPoint {
        return CGPoint(
            x: (prev.x + cur.x) / 2,
            y: (prev.y + cur.y) / 2
        )
    }
}
