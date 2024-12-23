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
                ColorPickerView(setColor: canvasData.setColor)
                    .padding(10)
                Spacer()
                HStack(spacing: 16) {
                    Button("Reset") {
                        canvasData.reset()
                    }
                    Button("Undo") {
                        canvasData.undo()
                    }
                    Button("Draw") {
                        canvasData.setSize(newSize: 2.0)
                        canvasData.setColor(newColor: .white)
                        mode.mode = .draw
                    }
                    Button("Erase") {
                        canvasData.setSize(newSize: 15.0)
                        canvasData.setColor(newColor: ColorManager.backgroundColor)
                        mode.mode = .erase
                    }
                    Button("Pan") {
                        mode.mode = .pan
                    }
                }
                .padding(16)
            }
        }
        .background(ColorManager.backgroundColor)
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
