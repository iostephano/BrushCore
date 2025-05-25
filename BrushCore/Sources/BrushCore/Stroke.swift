//
//  Stroke.swift
//  BrushCore
//
//  Created by Stephano Portella on 24/05/25.
//

import UIKit

public struct Stroke {
    public var points: [CGPoint]
    public var brush: Brush

    public init(points: [CGPoint], brush: Brush) {
        self.points = points
        self.brush = brush
    }
}
