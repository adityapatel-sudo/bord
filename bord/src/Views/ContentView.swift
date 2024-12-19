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

    var body: some View {
        ZStack {
            CanvasView(data: canvasData)
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
                        mode.mode = .draw
                        canvasData.setColor(color: .white)
                    }
                    Button("Erase") {
                        mode.mode = .erase
                        canvasData.setColor(color: .black)
                    }
                    Button("Pan") {
                        mode.mode = .pan
                    }
                }
                .padding(16)
            }
        }
    }
    private func hello() {
        print("hello")
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
