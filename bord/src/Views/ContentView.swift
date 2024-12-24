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
    @StateObject private var lineViewModel = LineViewModel()
    @StateObject private var mode = CanvasModeViewModel()
    var body: some View {
        ZStack {
            CanvasView(lineVM: lineViewModel, modeVM: mode)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
           
            VStack {
                ColorPickerView(lineViewModel: lineViewModel)
                    .padding(10)
                    .offset(y: mode.mode != .draw ? -100 : 0) // Move off-screen upwards
                    .animation(.easeInOut, value: mode.mode != .draw) // Animate the transition
                Spacer()

                ZStack(alignment: .bottom) {
                    BottomToolbarView(canvasModeVM: mode, lineVM: lineViewModel)
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
