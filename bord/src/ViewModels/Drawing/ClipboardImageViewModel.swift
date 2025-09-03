//
//  ClipboardImageViewModel.swift
//  bord
//
//  Created by Aditya Patel on 4/5/25.
//

import Foundation
import SwiftUI

class ClipboardImageViewModel: ObservableObject {
    @Published var images: [ClipboardImageModel] = []

    func addImage(_ image: NSImage, at position: CGPoint = CGPoint(x: 100, y: 100)) {
        let newImage = ClipboardImageModel(image: image, position: .init(width: position.x, height: position.y))
        images.append(newImage)
        objectWillChange.send()
    }

    func pasteImageFromClipboard() {
        let pasteboard = NSPasteboard.general

        if let image = NSImage(pasteboard: pasteboard) {
            DispatchQueue.main.async {
                self.addImage(image)
            }
        } else {
            print("No image found in pasteboard")
        }
    }
}
