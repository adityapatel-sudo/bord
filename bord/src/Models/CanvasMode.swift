//
//  CanvasMode.swift
//  bord
//
//  Created by Aditya Patel on 12/18/24.
//

import Foundation

enum CanvasMode {
    case draw
    case erase
    case pan
}

class CanvasModeViewModel: ObservableObject {
    @Published var mode: CanvasMode = .draw
}
