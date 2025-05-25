//
//  BrushRenderer.swift
//  BrushCore
//
//  Created by Stephano Portella on 24/05/25.
//

import UIKit

public class BrushRenderer {
    public init() {}

    public func drawStroke(_ stroke: Stroke, in context: CGContext) {
        let colors: [UIColor] = [.red, .yellow, .green, .blue]
        let totalBands = colors.count

        let totalThickness = stroke.brush.size
        let bandThickness = totalThickness / CGFloat(totalBands) * 9.5
        let bandSpacing: CGFloat = bandThickness * 0.8

        context.setLineCap(.round)

        for i in 0..<totalBands {
            let offsetY = CGFloat(i - totalBands / 2) * bandSpacing + bandSpacing / 2
            let color = colors[i].withAlphaComponent(stroke.brush.opacity).cgColor
            context.setStrokeColor(color)
            context.setLineWidth(bandThickness)

            context.beginPath()

            if let first = stroke.points.first {
                context.move(to: CGPoint(x: first.x, y: first.y + offsetY))
            }

            for point in stroke.points.dropFirst() {
                let offsetPoint = CGPoint(x: point.x, y: point.y + offsetY)
                context.addLine(to: offsetPoint)
            }

            context.strokePath()
        }
    }
}
