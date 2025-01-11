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
    @State var extraDetails: Bool = false
    @State var textAlignment: TextAlignment = .center

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
                                    text.width = min(max(80, text.width - value.translation.width), 1500)
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
                    .font(.system(
                        size: text.fontSize,
                        weight: text.isBold ? .heavy : .bold)
                    )
                    .italic(text.isItalics)
                    .foregroundStyle(text.color)
                    .onTapGesture { isFocused = true }
                    .onExitCommand {
                        if temporaryText.isEmpty {
                            canvasVM.remove(text: text)
                        }
                        isFocused = false
                    }
                    .onSubmit {
                        if temporaryText.isEmpty {
                            canvasVM.remove(text: text)
                        }
                        text.text = temporaryText
                        isFocused = false
                    }
                    .textFieldStyle(.plain)
                    .frame(
                        width: max(50, text.width)
                    )
                    .multilineTextAlignment(.center)
                    .onChange(of: isFocused) {
                        if !isFocused && !isDragging && temporaryText.isEmpty {
                            canvasVM.remove(text: text)
                        }
                        text.text = temporaryText
                        text.isFocused = isFocused
                    }
                    .onChange(of: canvasVM.color) { _, color in
                        if isFocused {
                            text.setColor(to: color)
                        }
                    }
                    .saveHeight(in: text)
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
        .onChange(of: text.isFocused) { _, _ in
            isFocused = text.isFocused
        }
        .onChange(of: isFocused) { _, _ in
            text.isFocused = isFocused
        }
        .overlay(alignment: .top) {
            if isFocused || isDragging {
                HStack(spacing: 0) {
                    CanvasButton(
                        imageName: "chevron.up",
                        isSelected: extraDetails,
                        onTap: {
                            extraDetails.toggle()
                        },
                        imageSize: .medium,
                        imageFrameSize: 40,
                        highlightSize: 35,
                        cornerRadius: 8
                    )
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
                                    text.movePosition(by: value.translation)
                                }
                                .onEnded { _ in
                                    isFocused = true
                                    isDragging = false
                                }
                        )
                    CanvasButton(
                        imageName: "doc.on.doc",
                        isSelected: false,
                        onTap: {
                            canvasVM.duplicateText(text: text)
                        },
                        imageSize: .medium,
                        imageFrameSize: 40
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
                .overlay(alignment: .topLeading) {
                    if (isFocused || isDragging) && extraDetails {
                        HStack(spacing: 0) {
                            CanvasButton(
                                imageName: "rotate.left",
                                isSelected: false,
                                onTap: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        text.rotateLeft()
                                    }
                                },
                                imageSize: .medium,
                                imageFrameSize: 40
                            )
                            CanvasButton(
                                imageName: "rotate.right",
                                isSelected: false,
                                onTap: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        text.rotateRight()
                                    }
                                },
                                imageSize: .medium,
                                imageFrameSize: 40
                            )
                            CanvasButton(
                                imageName: "italic",
                                isSelected: text.isItalics,
                                onTap: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        text.isItalics.toggle()
                                        text.objectWillChange.send()
                                    }
                                },
                                imageSize: .medium,
                                imageFrameSize: 40,
                                highlightSize: 35,
                                cornerRadius: 8
                            )
                            CanvasButton(
                                imageName: "bold",
                                isSelected: text.isBold,
                                onTap: {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        text.isBold.toggle()
                                        text.objectWillChange.send()
                                    }
                                },
                                imageSize: .medium,
                                imageFrameSize: 40,
                                highlightSize: 35,
                                cornerRadius: 8
                            )
//                            CanvasButton(
//                                imageName: "text.alignleft",
//                                isSelected: text.textAlignment == .leading,
//                                onTap: {
//                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
//                                        text.setTextAlignment(to: .leading)
//                                        textAlignment = .leading
//                                    }
//                                },
//                                imageSize: .medium,
//                                imageFrameSize: 40,
//                                highlightSize: 35,
//                                cornerRadius: 8
//                            )
//                            CanvasButton(
//                                imageName: "text.aligncenter",
//                                isSelected: text.textAlignment == .center,
//                                onTap: {
//                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
//                                        text.setTextAlignment(to: .center)
//                                        textAlignment = .center
//                                    }
//                                },
//                                imageSize: .medium,
//                                imageFrameSize: 40,
//                                highlightSize: 35,
//                                cornerRadius: 8
//                            )
//                            CanvasButton(
//                                imageName: "text.alignright",
//                                isSelected: text.textAlignment == .trailing,
//                                onTap: {
//                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
//                                        text.setTextAlignment(to: .trailing)
//                                        textAlignment = .trailing
//                                    }
//                                },
//                                imageSize: .medium,
//                                imageFrameSize: 40,
//                                highlightSize: 35,
//                                cornerRadius: 8
//                            )
                        }
                        .background(ColorManager.lighterGrey)
                        .cornerRadius(10)
                        .padding(5)
                        .offset(y: -100)
                    }
                }
            }
        }
        .position(
            x: text.position.x + modeVM.currentPanOffset.width,
            y: text.position.y + modeVM.currentPanOffset.height
        )
    }
}
