//
//  BrushRenderer.swift
//  BrushCore
//
//  Created by Stephano Portella on 24/05/25.
//

import CoreGraphics

/// Dibuja un `Stroke` como un arcoíris de cuatro bandas paralelas
/// (rojo, amarillo, verde, azul) sobre un `CGContext`.
public struct BrushRenderer {

    public init() {}

    /// Una banda del arcoíris: su desplazamiento respecto al eje del trazo y su
    /// grosor de línea, ambos en puntos.
    struct Band: Equatable, Sendable {
        let offset: CGFloat
        let thickness: CGFloat
    }

    /// Colores del arcoíris, de arriba (offset negativo) a abajo, en sRGB.
    static let bandColors: [CGColor] = [
        CGColor(srgbRed: 1.00, green: 0.23, blue: 0.19, alpha: 1),
        CGColor(srgbRed: 1.00, green: 0.80, blue: 0.00, alpha: 1),
        CGColor(srgbRed: 0.30, green: 0.85, blue: 0.39, alpha: 1),
        CGColor(srgbRed: 0.00, green: 0.48, blue: 1.00, alpha: 1)
    ]

    /// Cuánto más ancha es cada banda respecto a su porción exacta del grosor
    /// total. Al pasar de 1 las bandas se solapan, lo que evita huecos de color
    /// entre ellas al curvarse el trazo.
    static let bandOverlap: CGFloat = 1.6

    /// Reparte `thickness` (el grosor total del arcoíris) entre las cuatro
    /// bandas: todas con el mismo grosor y con los centros repartidos de forma
    /// simétrica respecto al eje del trazo.
    static func bands(forThickness thickness: CGFloat) -> [Band] {
        let count = bandColors.count
        let bandThickness = thickness / CGFloat(count) * bandOverlap
        let span = max(thickness - bandThickness, 0)
        let step = count > 1 ? span / CGFloat(count - 1) : 0
        return (0..<count).map { i in
            Band(offset: -span / 2 + step * CGFloat(i), thickness: bandThickness)
        }
    }

    public func drawStroke(_ stroke: Stroke, in context: CGContext) {
        guard stroke.points.count > 1, stroke.brush.size > 0 else { return }

        context.saveGState()
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.setAlpha(stroke.brush.opacity)

        for (band, color) in zip(Self.bands(forThickness: stroke.brush.size), Self.bandColors) {
            context.setStrokeColor(color)
            context.setLineWidth(band.thickness)
            context.beginPath()
            context.addLines(between: stroke.points.map { CGPoint(x: $0.x, y: $0.y + band.offset) })
            context.strokePath()
        }

        context.restoreGState()
    }
}
