//
//  CanvasButton.swift
//  bord
//
//  Created by Aditya Patel on 12/25/24.
//

import SwiftUI

struct CanvasButton: View {
    let imageName: String
    var isSelected: Bool
    var onTap: () -> Void
    var highlighted: Bool = false
    var imageSize: Image.Scale = .large
    var imageFrameSize: CGFloat = 50
    var highlightSize: CGFloat = 40
    var cornerRadius: CGFloat = 10

    var shortcut: KeyboardShortcut?
    @State private var isHovered = false
    var body: some View {
        Button {
            onTap()
        } label: {
            ZStack {
                highlighted ? (
                    Image(systemName: imageName)
                        .frame(width: imageFrameSize, height: imageFrameSize)
                        .imageScale(imageSize)
                        .foregroundColor(isHovered ? .gray : .green)
                ) : (
                    Image(systemName: imageName)
                        .frame(width: imageFrameSize, height: imageFrameSize)
                        .imageScale(imageSize)
                        .foregroundColor(isHovered ? .gray : .white)
                )
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.green.opacity(isSelected ? 0.25 : 0))
                    .frame(width: highlightSize, height: highlightSize)
            }
            .onHover { hovering in
                isHovered = hovering
            }
        }
        .buttonStyle(PlainButtonStyle())
        .keyboardShortcut(shortcut)
    }
}

#Preview {
    CanvasButton(
        imageName: "pencil.and.scribble",
        isSelected: true,
        onTap: {print("Pencil button tapped")}
    )
}
