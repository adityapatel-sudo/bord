//
//  ClipboardImageView.swift
//  bord
//
//  Created by Aditya Patel on 4/5/25.
//

import SwiftUI

struct ClipboardImageView: View {
    @Binding var imageModel: ClipboardImageModel
    @State private var dragOffset: CGSize = .zero
    @State private var currentScale: CGFloat = 1.0

    var body: some View {
        Image(nsImage: imageModel.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            // Apply the scaling and position from the model plus gesture state
            .scaleEffect(imageModel.scale * currentScale)
            .offset(x: imageModel.position.width + dragOffset.width,
                    y: imageModel.position.height + dragOffset.height)
            // Drag gesture to update position
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        imageModel.position.width += value.translation.width
                        imageModel.position.height += value.translation.height
                        dragOffset = .zero
                    }
            )
            // Magnification gesture to update scale
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        currentScale = value
                    }
                    .onEnded { value in
                        imageModel.scale *= value
                        currentScale = 1.0
                    }
            )
    }
}
