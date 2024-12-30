//
//  HeightCalculator.swift
//  bord
//
//  Created by Aditya Patel on 12/30/24.
//

import Foundation
import SwiftUI

struct HeightCalculator: ViewModifier {

    @ObservedObject var text: TextModel

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear // we just want the reader to get triggered, so let's use an empty color
                        .onAppear {
                            text.height = proxy.frame(in: .global).height
                        }
                        .onChange(of: proxy.frame(in: .global).height) {
                            text.height = proxy.frame(in: .global).height
                        }
                }
            )
    }
}

extension View {
    func saveHeight(in text: TextModel) -> some View {
        modifier(HeightCalculator(text: text))
    }
}
