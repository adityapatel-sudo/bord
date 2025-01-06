//
//  CanvasDrawingUtils.swift
//  bord
//
//  Created by Aditya Patel on 1/2/25.
//

import Foundation
import SwiftUI

extension CanvasView {
    /// Draws the grid or lines based on the current grid mode.
    /// - Parameters:
    ///   - context: The graphics context to draw the grid or lines.
    ///   - screenSize: The size of the screen.
    func drawGridOrLines(_ context: GraphicsContext, _ screenSize: CGSize) {
        if modeVM.gridMode == .grid {
            drawGrid(context, screenSize)
        } else if modeVM.gridMode == .lines {
            drawHorizontalLines(context, screenSize)
        }
    }

    /// Draws the drawn lines on the canvas. Includes selected lines with a dashed line style.
    /// - Parameter context: The graphics context to draw the lines.
    func drawLines(_ context: inout GraphicsContext) {
        // Draw the lines, translated by the current pan offset
        context.translateBy(x: modeVM.currentPanOffset.width, y: modeVM.currentPanOffset.height)
        for line in canvasVM.drawn {
            var strokeStyle = StrokeStyle(lineWidth: line.lineWidth, lineCap: .round)
            if line.isSelected {
                strokeStyle = StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, dash: [line.lineWidth * 5])
            }
            context.stroke(
                line.path.applying(line.transform),
                with: .color(line.color),
                style: strokeStyle
            )
        }
    }

    func drawBackground(_ context: GraphicsContext, _ screenSize: CGSize) {
        // Draw a black rectangle around the canvas to show the canvas boundary
        let canvasRect = CGRect(origin: .zero, size: canvasSize)
        let screenRect = CGRect(
            origin: CGPoint(x: -modeVM.currentPanOffset.width, y: -modeVM.currentPanOffset.height),
            size: screenSize
        )
        var canvasPath = Path()
        canvasPath.addRect(screenRect)
        canvasPath.addRect(canvasRect)
        context.fill(
            canvasPath,
            with: .color(ColorManager.uneditableBackground),
            style: FillStyle(eoFill: true)
        )
    }

    func drawGrid(
        _ context: GraphicsContext,
        _ size: CGSize,
        _ gridSpacing: CGFloat.Stride = CGFloat.Stride(50)
    ) {
        // Draw horizontal lines
        drawHorizontalLines(context, size, gridSpacing)
        // Draw vertical lines
        for xLines in stride(from: modeVM.currentPanOffset.width, through: size.width, by: gridSpacing) {
            let startPoint = CGPoint(x: xLines, y: 0)
            let endPoint = CGPoint(x: xLines, y: size.height)
            context.stroke(
                Path { path in
                    path.move(to: startPoint)
                    path.addLine(to: endPoint)
                },
                with: .color(.gray),
                lineWidth: 0.5
            )
        }
    }

    func drawHorizontalLines(
        _ context: GraphicsContext,
        _ size: CGSize,
        _ gridSpacing: CGFloat.Stride = CGFloat.Stride(50)
    ) {
        for yLines in stride(
            from: modeVM.currentPanOffset.height,
            through: size.height,
            by: gridSpacing
        ) {
            let startPoint = CGPoint(x: 0, y: yLines)
            let endPoint = CGPoint(x: size.width, y: yLines)
            context.stroke(
                Path { path in
                    path.move(to: startPoint)
                    path.addLine(to: endPoint)
                },
                with: .color(.gray),
                lineWidth: 0.5
            )
        }
    }
}
