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
            ZStack {
                Image(systemName: "circle.circle")
                    .frame(width: 45, height: 45)
                    .imageScale(.large)
                    .foregroundColor(hover ? .gray : .orange)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                canvasModeVM.updatePanOffset(offset: .zero)
            }
            .onHover(perform: { hovering in
                hover = hovering
            })

        }
        .padding(5)
        .background(ColorManager.lighterGrey)
        .cornerRadius(15)
    }
}

struct CenterCanvasView_Previews: PreviewProvider {
    @StateObject static var canvasModeVM = CanvasModeViewModel()
    static var previews: some View {
        CenterCanvasView(canvasModeVM: canvasModeVM)
    }
}
