//
//  CenterCanvasView.swift
//  bord
//
//  Created by Aditya Patel on 12/25/24.
//

import SwiftUI

struct CenterCanvasView: View {
    @ObservedObject var canvasModeVM: CanvasModeViewModel
    @State var hover = false
    var body: some View {
        HStack {
            CanvasButton(
                imageName: "mappin.and.ellipse",
                isSelected: false,
                onTap: {
                    canvasModeVM.resetOffset()
                },
                orange: true
            )
        }
        .padding(5)
        .background(ColorManager.lighterGrey)
        .cornerRadius(15)

    }
}

struct CenterCanvasView_Previews: PreviewProvider {
    @StateObject static var canvasModeVM = CanvasModeViewModel(panOffset: .zero)
    static var previews: some View {
        CenterCanvasView(canvasModeVM: canvasModeVM)
    }
}
