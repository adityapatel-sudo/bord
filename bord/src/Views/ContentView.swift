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
    @StateObject private var mode = CanvasModeViewModel()
    var body: some View {
        ZStack {
            CanvasView(canvasVM: canvasVM, modeVM: mode)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
           
            VStack {
                ColorPickerView(canvasVM: canvasVM)
                    .padding(10)
                    .offset(y: mode.mode == .pan || mode.mode == .erase ? -100 : 0)
                    .animation(.easeInOut, value: mode.mode == .pan || mode.mode == .erase)
                Spacer()

                ZStack(alignment: .bottom) {
                    HStack(alignment: .bottom, spacing: 10) {
                        SizePickerView(canvasVM: canvasVM)
                        DrawingToolbarView(canvasModeVM: mode, canvasVM: canvasVM)
                        BottomToolbarView(canvasModeVM: mode, canvasVM: canvasVM)
                    }
                    .padding(10)
                    HStack {
                        if mode.panOffset != .zero {
                            CenterCanvasView(canvasModeVM: mode)
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
