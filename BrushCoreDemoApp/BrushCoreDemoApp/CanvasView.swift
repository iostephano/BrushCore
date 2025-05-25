//
//  CanvasView.swift
//  BrushCoreDemoApp
//
//  Created by Stephano Portella on 24/05/25.
//
import UIKit
import BrushCore

class CanvasView: UIView {
    private var strokes: [Stroke] = []
    private var currentPoints: [CGPoint] = []
    private let renderer = BrushRenderer()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentPoints = []
        if let point = touches.first?.location(in: self) {
            currentPoints.append(point)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self) {
            currentPoints.append(point)
            setNeedsDisplay()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let stroke = Stroke(points: currentPoints, brush: BrushSettings.current)
        strokes.append(stroke)
        currentPoints = []
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        for stroke in strokes {
            renderer.drawStroke(stroke, in: context)
        }

        if !currentPoints.isEmpty {
            let previewStroke = Stroke(points: currentPoints, brush: BrushSettings.current)
            renderer.drawStroke(previewStroke, in: context)
        }
    }
}

