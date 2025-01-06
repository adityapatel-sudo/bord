//
//  CanvasDragUtils.swift
//  bord
//
//  Created by Aditya Patel on 1/2/25.
//

import Foundation
import SwiftUI

extension CanvasView {
    // swiftlint:disable:next cyclomatic_complexity
     func handleDragChanged(_ value: DragGesture.Value, isCMDPressed: Bool = false) {
        let offsetPoint = CGPoint(
            x: value.location.x - modeVM.currentPanOffset.width,
            y: value.location.y - modeVM.currentPanOffset.height
        )
        switch modeVM.mode {
        case .draw:
            switch canvasVM.drawEndMode {
            case .plain:
                canvasVM.newDraw(point: offsetPoint)
            case .arrow:
                canvasVM.newDrawnArrow(point: offsetPoint)
            case .twoEndArrow:
                canvasVM.newTwoDrawnArrow(point: offsetPoint)
            }
        case .erase:
            handleEraseStroke(offsetPoint)
        case .select:
            handleSelectStroke(value, offsetPoint, isCMDPressed: isCMDPressed)
        case .line:
            canvasVM.newLine(point: offsetPoint)
        case .arrow:
            canvasVM.newArrow(point: offsetPoint)
        case .rectangle:
            canvasVM.newRectangle(point: offsetPoint, isEllipse: false)
        case .elipse:
            canvasVM.newRectangle(point: offsetPoint, isEllipse: true)
        case .pan:
            // Handle panning
            let newOffset = CGSize(
                width: modeVM.panOffset.width + value.translation.width,
                height: modeVM.panOffset.height + value.translation.height
            )
            // Clamp the pan offset to the canvas
            modeVM.currentPanOffset.width = min(max(newOffset.width, -canvasSize.width), canvasSize.width)
            modeVM.currentPanOffset.height = min(max(newOffset.height, -canvasSize.height), canvasSize.height)
        default:
            break
        }
        canvasVM.updateSelectedSizeAndPos()
    }

    // swiftlint:disable:next cyclomatic_complexity
     func handleDragEnded(_ value: DragGesture.Value, isCMDPressed: Bool = false) {
        let offsetPoint = CGPoint(
            x: value.location.x - modeVM.currentPanOffset.width,
            y: value.location.y - modeVM.currentPanOffset.height
        )
        switch modeVM.mode {
        case .draw:
            switch canvasVM.drawEndMode {
            case .plain:
                canvasVM.endDraw()
            case .arrow:
                canvasVM.endDrawnArrow()
            case .twoEndArrow:
                canvasVM.endTwoDrawnArrow()
            }
        case .erase:
            for line in canvasVM.drawn where line.path.contains(offsetPoint) {
                canvasVM.remove(drawable: line)
            }
        case .select:
            canvasVM.isMoving = false
        case .line:
            canvasVM.endLine(point: offsetPoint)
        case .arrow:
            canvasVM.endArrow(point: offsetPoint)
        case .rectangle:
            canvasVM.endRectangle(point: offsetPoint)
        case .elipse:
            canvasVM.endRectangle(point: offsetPoint)
        case .pan:
            modeVM.panOffset.width += value.translation.width
            modeVM.panOffset.height += value.translation.height
        case .text:
            canvasVM.newText(at: offsetPoint)
        default:
            break
        }
    }

     func handleSelectStroke(
        _ value: DragGesture.Value,
        _ offsetPoint: CGPoint,
        isCMDPressed: Bool
    ) {
        if !canvasVM.isMoving {
            canvasVM.currentMoveOffset = value.location
            var selectedPath = canvasVM.drawn.last(where: { line in
                let strokedPath = line.path.applying(line.transform).cgPath.copy(
                    strokingWithWidth: line.lineWidth + 20,
                    lineCap: .round,
                    lineJoin: .round,
                    miterLimit: 0
                )
                return strokedPath.contains(offsetPoint)
            })
            if selectedPath == nil {
                if !isCMDPressed {
                    canvasVM.unselectAll()
                }
            } else {
                if selectedPath!.isSelected && !isCMDPressed {
                    canvasVM.unselectAll()
                    selectedPath!.isSelected = true
                } else if !selectedPath!.isSelected && isCMDPressed {
                    selectedPath!.isSelected = true
                } else if !selectedPath!.isSelected && !isCMDPressed {
                    canvasVM.unselectAll()
                    selectedPath!.isSelected = true
                }
            }
            canvasVM.objectWillChange.send()
        } else {
            let curDiff = CGSize(
                width: value.location.x - canvasVM.currentMoveOffset.x,
                height: value.location.y - canvasVM.currentMoveOffset.y
            )
            canvasVM.currentMoveOffset = value.location

            for inex in canvasVM.drawn.indices where canvasVM.drawn[inex].isSelected {
                canvasVM.movePath(&canvasVM.drawn[inex], by: curDiff)
                if let rect = canvasVM.drawn[inex] as? RectangleModel {
                    if canvasVM.isTextInShapes && rect.linkedText != nil {
                        rect.linkedText?.movePosition(by: curDiff)
                    }
                }
            }
        }
        canvasVM.isMoving = true
    }

     func handleEraseStroke(_ offsetPoint: CGPoint) {
        if let line = canvasVM.drawn.last(where: { line in
            let strokedPath = line.path.cgPath.copy(
                strokingWithWidth: line.lineWidth + 20
                ,
                lineCap: .round,
                lineJoin: .round,
                miterLimit: 0
            )
            return strokedPath.contains(offsetPoint)
        }) {
            canvasVM.remove(drawable: line)
        }
        if let text = canvasVM.texts.last(where: { text in
            return  text.position.x - 0.5 * text.width <= offsetPoint.x &&
            text.position.y - 0.5 * text.height <= offsetPoint.y &&
            text.position.x + 0.5 * text.width >= offsetPoint.x &&
            text.position.y + 0.5 * text.height >= offsetPoint.y
        }) {
            canvasVM.remove(text: text)
        }
    }

     func handleScroll(_ deltaX: CGFloat, _ deltaY: CGFloat) {
        modeVM.currentPanOffset.width += deltaX
        modeVM.currentPanOffset.height += deltaY

        modeVM.panOffset.width += deltaX
        modeVM.panOffset.height += deltaY
    }
}
