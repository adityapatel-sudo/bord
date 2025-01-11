//
//  CanvasModeViewModel.swift
//  bord
//
//  Created by Aditya Patel on 12/19/24.
//

import Foundation
import SwiftUI

class CanvasModeViewModel: ObservableObject {
    @Published var mode: CanvasMode = .draw
    @Published var gridMode: CanvasGridMode = .grid

    @Published var currentPanOffset: CGSize = .zero
    @Published var panOffset: CGSize = .zero
    @Published var shapesEnabled: Bool = false

    @Published var zoom: CGFloat = 1.0

    var defaultOffset: CGSize = .zero

    init() {}

    init(panOffset: CGSize) {
        self.panOffset = panOffset
        self.currentPanOffset = panOffset
        defaultOffset = panOffset
    }

    func resetOffset() {
        currentPanOffset = defaultOffset
        panOffset = defaultOffset
        objectWillChange.send()
    }

    func updatePanOffset(offset: CGSize) {
        currentPanOffset = offset
        panOffset = offset
        objectWillChange.send()
    }

    func isOffCenter() -> Bool {
        return panOffset != defaultOffset
    }

    func magnify(by value: MagnifyGesture.Value) {
        let result = zoom * sqrt(value.magnification)
        if result > 0.34 && result < 3 {
            zoom = result
        }
    }
}
