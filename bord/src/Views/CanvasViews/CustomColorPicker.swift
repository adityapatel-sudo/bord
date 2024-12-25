//
//  CustomColorPicker.swift
//  bord
//
//  Created by Aditya Patel on 12/23/24.
//

import SwiftUI
import Combine

struct CustomColorPicker: NSViewRepresentable {
    var onColorChange: (Color) -> Void

    func makeNSView(context: Context) -> NSColorWell {
        let colorWell = NSColorWell(style: .minimal)
        colorWell.target = context.coordinator
        colorWell.action = #selector(Coordinator.colorChanged(_:))
        return colorWell
    }

    func updateNSView(_ nsView: NSColorWell, context: Context) {
        // No need to update view here, action is handled by the coordinator
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onColorChange: onColorChange)
    }

    class Coordinator: NSObject {
        var onColorChange: (Color) -> Void

        init(onColorChange: @escaping (Color) -> Void) {
            self.onColorChange = onColorChange
        }

        @objc func colorChanged(_ sender: NSColorWell) {
            let color = Color(nsColor: sender.color)
            onColorChange(color)
        }
    }
}
