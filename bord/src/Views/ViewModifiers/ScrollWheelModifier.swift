//
//  ScrollWheelModifier.swift
//  bord
//
//  Created by Aditya Patel on 12/28/24.
//

import SwiftUI
import Combine

struct ScrollWheelModifier: ViewModifier {
    @State private var subs = Set<AnyCancellable>() // Cancel onDisappear

    var action: (CGFloat, CGFloat) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear { trackScrollWheel() }
    }

    func trackScrollWheel() {
        NSApp.publisher(for: \.currentEvent)
            .filter { event in event?.type == .scrollWheel }
            .throttle(for: .milliseconds(5), scheduler: RunLoop.main, latest: true)
            .sink {
                if let event = $0 {
                    action(event.deltaX, event.deltaY)
                }
            }
            .store(in: &subs)
    }
}

extension View {
    func onScrollWheelUp(action: @escaping (CGFloat, CGFloat) -> Void) -> some View {
        modifier(ScrollWheelModifier(action: action) )
    }
}
