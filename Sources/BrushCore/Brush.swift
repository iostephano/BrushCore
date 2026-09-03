//
//  Brush.swift
//  BrushCore
//
//  Created by Stephano Portella on 24/05/25.
//

import CoreGraphics

/// Parámetros de un trazo. `BrushCore` pinta siempre un arcoíris fijo
/// (rojo, amarillo, verde, azul), así que el color no es configurable: solo el
/// grosor total del arcoíris y su opacidad.
public struct Brush: Sendable, Equatable {

    /// Grosor total del arcoíris, en puntos (la suma del ancho de las cuatro
    /// bandas, no el de una sola).
    public var size: CGFloat

    /// Opacidad aplicada a cada banda, de 0 a 1.
    public var opacity: CGFloat

    public init(size: CGFloat, opacity: CGFloat) {
        self.size = size
        self.opacity = opacity
    }

    public static let `default` = Brush(size: 40, opacity: 1)
}
