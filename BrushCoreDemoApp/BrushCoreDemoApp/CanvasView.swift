//
//  CanvasView.swift
//  BrushCoreDemoApp
//
//  Created by Stephano Portella on 24/05/25.
//

import UIKit
import BrushCore

/// Lienzo de dibujo: acumula los trazos terminados y los redibuja todos con
/// `BrushRenderer` en cada `draw(_:)`. Es una demo, así que no hay límite de
/// trazos ni cacheo del resultado en un bitmap.
final class CanvasView: UIView {

    /// Pincel con el que se pintarán los próximos trazos.
    var brush: Brush = .default

    private let renderer = BrushRenderer()
    private var strokes: [Stroke] = []
    private var currentPoints: [CGPoint] = []

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        currentPoints = [point]
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        currentPoints.append(point)
        setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentPoints.count > 1 {
            strokes.append(Stroke(points: currentPoints, brush: brush))
        }
        currentPoints = []
        setNeedsDisplay()
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentPoints = []
        setNeedsDisplay()
    }

    /// Vacía el lienzo: descarta los trazos guardados y el que se esté pintando.
    func clear() {
        strokes.removeAll()
        currentPoints.removeAll()
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        for stroke in strokes {
            renderer.drawStroke(stroke, in: context)
        }
        if currentPoints.count > 1 {
            renderer.drawStroke(Stroke(points: currentPoints, brush: brush), in: context)
        }
    }
}
