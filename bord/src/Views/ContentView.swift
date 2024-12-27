//
//  ContentView.swift
//  bord
//
//  Created by Aditya Patel on 12/15/24.
//

import SwiftUI
import CoreData

struct ContentView: View {

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @StateObject private var canvasVM = CanvasItemsViewModel()
    @StateObject private var modeVM = CanvasModeViewModel(
        panOffset: CGSize(
            width: -(NSScreen.main?.frame.width ?? 1600),
            height: -(NSScreen.main?.frame.height ?? 900)
        )
    )

    var body: some View {
        ZStack {
            CanvasView(canvasVM: canvasVM, modeVM: modeVM)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                HStack {
                    GridPickerView(modeVM: modeVM)
                        .padding(10)
                    Spacer()
                }
                Spacer()
            }

            VStack {
                let colorPickerVisible = modeVM.mode == .pan || modeVM.mode == .erase || modeVM.mode == .select
                ColorPickerView(canvasVM: canvasVM)
                    .padding(10)
                    .offset(y: colorPickerVisible ? -100 : 0)
                    .animation(.easeInOut, value: colorPickerVisible)
                Spacer()

                ZStack(alignment: .bottom) {
                    HStack(alignment: .bottom, spacing: 10) {
                        let sizePickerVisible = modeVM.mode == .draw || modeVM.mode == .line ||
                            modeVM.mode == .rectangle
                        if sizePickerVisible {
                            SizePickerView(canvasVM: canvasVM)
                        }
                        DrawingToolbarView(canvasModeVM: modeVM, canvasVM: canvasVM)
                        BottomToolbarView(canvasModeVM: modeVM, canvasVM: canvasVM)
                    }
                    .padding(10)
                    HStack(alignment: .bottom) {
                        if modeVM.isOffCenter() {
                            CenterCanvasView(canvasModeVM: modeVM)
                                .padding(10)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
