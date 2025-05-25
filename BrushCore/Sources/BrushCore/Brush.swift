//
//  Brush.swift
//  BrushCore
//
//  Created by Stephano Portella on 24/05/25.
//

import UIKit

public struct Brush {
    public var color: UIColor
    public var size: CGFloat
    public var opacity: CGFloat

    public init(color: UIColor, size: CGFloat, opacity: CGFloat) {
        self.color = color
        self.size = size
        self.opacity = opacity
    }
}
