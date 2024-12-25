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
    var orange: Bool = false
    @State private var isHovered = false
    var body: some View {
        ZStack {
            orange ? (
                Image(systemName: imageName)
                    .frame(width: 50, height: 50)
                    .imageScale(.large)
                    .foregroundColor(isHovered ? .gray : .orange)
            ) : (
                Image(systemName: imageName)
                    .frame(width: 50, height: 50)
                    .imageScale(.large)
                    .foregroundColor(isHovered ? .gray : .white)
            )
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.orange.opacity(isSelected ? 0.25 : 0))
                .frame(width: 40, height: 40)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

#Preview {
    CanvasButton(
        imageName: "pencil.and.scribble",
        isSelected: true,
        onTap: {print("Pencil button tapped")}
    )
}
