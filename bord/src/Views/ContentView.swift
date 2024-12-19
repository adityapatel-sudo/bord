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
    @State private var backgroundColor: Color = .black
    var body: some View {
        ZStack {
            CanvasView(data: canvasData, mode: mode)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack {
                Spacer()
                HStack(spacing: 16) {
                    Button("Reset") {
                        canvasData.reset()
                    }
                    Button("Undo") {
                        canvasData.undo()
                    }
                    Button("Draw") {
                        canvasData.setColor(newColor: .white)
                        mode.mode = .draw
                    }
                    Button("Erase") {
                        canvasData.setColor(newColor: .black)
                        mode.mode = .erase
                    }
                    Button("Pan") {
                        mode.mode = .pan
                    }
                }
                .padding(16)
            }
        }
        .background(backgroundColor)
    }
    private func hello() {
        print("hello")
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
