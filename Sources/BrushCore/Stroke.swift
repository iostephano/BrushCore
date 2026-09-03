//
//  Stroke.swift
//  BrushCore
//
//  Created by Stephano Portella on 24/05/25.
//

import CoreGraphics

/// Un trazo: la secuencia de puntos que siguió el dedo y el pincel con el que se
/// pintó.
public struct Stroke: Sendable, Equatable {
    public var points: [CGPoint]
    public var brush: Brush

    public init(points: [CGPoint], brush: Brush) {
        self.points = points
        self.brush = brush
    }
}
