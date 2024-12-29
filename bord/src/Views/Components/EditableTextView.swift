//
//  EditableTextView.swift
//  bord
//
//  Created by Aditya Patel on 12/29/24.
//

import SwiftUI

struct EditableTextView: View {
    @ObservedObject var text: TextModel

    @State var temporaryText: String
    @State var currentWidthDiff: CGFloat = 0
    @FocusState var isFocused: Bool
    @State var isDragging: Bool = false

    var body: some View {
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
                .onTapGesture { isFocused = true }
                .onExitCommand { isFocused = false }
                .textFieldStyle(.plain)
                .frame(width: text.width)
                .multilineTextAlignment(.center)
                .onChange(of: temporaryText) { _, newValue in
                    text.text = newValue
                }
            if isDragging || isFocused {
                Circle()
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                isDragging = true
                                isFocused = false
                                text.width = min(max(40, text.width + value.translation.width), 1500)
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
    }
}
