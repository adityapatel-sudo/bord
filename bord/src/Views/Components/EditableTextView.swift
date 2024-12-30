//
//  EditableTextView.swift
//  bord
//
//  Created by Aditya Patel on 12/29/24.
//

import SwiftUI

struct EditableTextView: View {
    @ObservedObject var canvasVM: CanvasItemsViewModel
    @ObservedObject var modeVM: CanvasModeViewModel
    @ObservedObject var text: TextModel

    @State var temporaryText: String
    @FocusState var isFocused: Bool
    @State var isDragging: Bool = false

    var body: some View {
        VStack {
            HStack {
                if isDragging || isFocused {
                    Circle()
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    isDragging = true
                                    isFocused = false
                                    text.width = min(max(20, text.width - value.translation.width), 1500)
                                }
                                .onEnded { _ in
                                    isDragging = false
                                    isFocused = true
                                }
                         )
                        .frame(width: 15, height: 15)
                }
                TextField("", text: $temporaryText, axis: .vertical)
                    .focused($isFocused, equals: true)
                    .font(.system(size: text.fontSize, weight: .bold))
                    .foregroundStyle(text.color)
                    .onTapGesture { isFocused = true }
                    .onExitCommand {
                        isFocused = false
                        if text.text.isEmpty {
                            canvasVM.remove(text: text)
                        }
                    }
                    .onSubmit {
                        if text.text.isEmpty {
                            canvasVM.remove(text: text)
                        }
                    }
                    .textFieldStyle(.plain)
                    .frame(width: text.width)
                    .multilineTextAlignment(.center)
                    .onChange(of: temporaryText) { _, newValue in
                        text.text = newValue
                    }
                    .onChange(of: isFocused) {
                        if !isFocused && text.text.isEmpty {
                            canvasVM.remove(text: text)
                        }
                    }
                if isDragging || isFocused {
                    Circle()
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    isDragging = true
                                    isFocused = false
                                    text.width = min(max(80, text.width + value.translation.width), 1500)
                                }
                                .onEnded { _ in
                                    isDragging = false
                                    isFocused = true
                                }
                        )
                        .frame(width: 15, height: 15)
                }
            }
            .onAppear {
                isFocused = true
            }
            .rotationEffect(.degrees(text.rotation))
        }
        .overlay(alignment: .top) {
            if isFocused || isDragging {
                HStack(spacing: 0) {
                    CanvasButton(
                        imageName: "textformat.size.smaller",
                        isSelected: false,
                        onTap: {
                            text.decreaseSize()
                        },
                        imageSize: .medium,
                        imageFrameSize: 40
                    )
                    CanvasButton(
                        imageName: "textformat.size.larger",
                        isSelected: false,
                        onTap: {
                            text.increaseSize()
                        },
                        imageSize: .medium,
                        imageFrameSize: 40
                    )
                    CanvasButton(
                        imageName: "rotate.right",
                        isSelected: false,
                        onTap: {
                            text.rotation += 45
                            text.objectWillChange.send()
                        },
                        imageSize: .medium,
                        imageFrameSize: 40
                    )

                    CanvasButton(
                        imageName: "arrow.up.and.down.and.arrow.left.and.right",
                        isSelected: false,
                        onTap: {},
                        imageSize: .medium,
                        imageFrameSize: 40
                    )
                        .highPriorityGesture(
                            DragGesture()
                                .onChanged { value in
                                    isFocused = false
                                    isDragging = true
                                    print("dragging box to \(value.translation)")
                                    text.position.x += value.translation.width
                                    text.position.y += value.translation.height
                                    text.objectWillChange.send()
                                }
                                .onEnded { _ in
                                    isFocused = true
                                    isDragging = false
                                }
                        )
                    CanvasButton(
                        imageName: "clear",
                        isSelected: false,
                        onTap: {
                            canvasVM.remove(text: text)
                        },
                        imageSize: .medium,
                        imageFrameSize: 40
                    )

                }
                .background(ColorManager.lighterGrey)
                .cornerRadius(10)
                .padding(5)
                .offset(y: -50)
            }
        }
        .position(
            x: text.position.x + modeVM.currentPanOffset.width,
            y: text.position.y + modeVM.currentPanOffset.height
        )
    }
}
