//
//  Line.swift
//  bord/Users/adityapatel/XCodeApps/bord/bord/src/Models/LineModel.swift
//
//  Created by Aditya Patel on 12/15/24.
//

import Foundation
import SwiftUI

class LineModel: DrawableModel, ObservableObject {
    @Published var isSelected: Bool = false
    @Published var height: CGFloat = 0
    @Published var width: CGFloat = 0

    var id: UUID = UUID()
    var lineWidth: Double
    var path: Path = Path()
    var color: Color
    var points = [CGPoint]()

    init() {
        self.color = Color.white
        self.lineWidth = 5
    }

    init(color: Color, lineWidth: Double) {
        self.color = color
        self.lineWidth = lineWidth
    }
    static func == (lhs: LineModel, rhs: LineModel) -> Bool {
        lhs.id == rhs.id
    }
    func updatePath(with newPath: Path) {
        path = newPath
    }
}
