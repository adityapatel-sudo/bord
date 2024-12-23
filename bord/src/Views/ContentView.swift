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
    @StateObject private var canvasData = LineViewModel()
    @StateObject private var mode = CanvasModeViewModel()
    var body: some View {
        ZStack {
            CanvasView(data: canvasData, mode: mode)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                ColorPickerView(canvas: canvasData)
                    .padding(10)
                Spacer()
                BottomToolbarView(mode: mode, canvas: canvasData)
                    .padding(10)}
        }
        .background(ColorManager.backgroundColor)
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
