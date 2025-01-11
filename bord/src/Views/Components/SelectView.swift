//
//  SelectView.swift
//  bord
//
//  Created by Aditya Patel on 1/2/25.
//

import SwiftUI

struct SelectView: View {
    @ObservedObject var canvasVM: CanvasItemsViewModel
    @ObservedObject var modeVM: CanvasModeViewModel

    var body: some View {
        let selected = canvasVM.drawn.filter { $0.isSelected }
        if selected.count == 1 {
            if let rect = selected[0] as? RectangleModel {
                RectangleSelectView(canvasVM: canvasVM, modeVM: modeVM, rect: rect)
                
            } else if let line = selected[0] as? LineModel {
                
            }
        }
    }
}
