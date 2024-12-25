//
//  CanvasModeViewModel.swift
//  bord
//
//  Created by Aditya Patel on 12/19/24.
//

import Foundation

class CanvasModeViewModel: ObservableObject {
    @Published var mode: CanvasMode = .draw
    @Published var currentPanOffset: CGSize = .zero
    @Published var panOffset: CGSize = .zero

    func updatePanOffset(offset: CGSize) {
        currentPanOffset = offset
        panOffset = offset
        objectWillChange.send()
    }
}
