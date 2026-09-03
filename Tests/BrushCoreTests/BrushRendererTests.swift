//
//  BrushRendererTests.swift
//  BrushCoreTests
//
//  Created by Stephano Portella on 03/09/26.
//

import Testing
import CoreGraphics
@testable import BrushCore

struct BrushRendererTests {

    // MARK: - bands(forThickness:)

    @Test("There is always one band per rainbow color")
    func bandCountMatchesColors() {
        #expect(BrushRenderer.bands(forThickness: 40).count == BrushRenderer.bandColors.count)
    }

    @Test("Every band has the same thickness, a fixed fraction of the total")
    func bandsShareThickness() {
        let bands = BrushRenderer.bands(forThickness: 40)
        let expected = 40 / 4 * BrushRenderer.bandOverlap
        #expect(bands.allSatisfy { abs($0.thickness - expected) < 0.0001 })
    }

    @Test("Band centers are symmetric about the stroke axis")
    func bandsAreSymmetric() {
        let offsets = BrushRenderer.bands(forThickness: 37).map(\.offset)
        #expect(abs(offsets.reduce(0, +)) < 0.0001)
        for (front, back) in zip(offsets, offsets.reversed()) {
            #expect(abs(front + back) < 0.0001)
        }
    }

    @Test("Band centers run from top to bottom in order")
    func bandsAreOrdered() {
        let offsets = BrushRenderer.bands(forThickness: 50).map(\.offset)
        #expect(offsets == offsets.sorted())
    }

    @Test("The outer edges of the outer bands span exactly the requested thickness")
    func bandsSpanTheThickness() {
        let thickness: CGFloat = 60
        let bands = BrushRenderer.bands(forThickness: thickness)
        let top = bands.first!.offset - bands.first!.thickness / 2
        let bottom = bands.last!.offset + bands.last!.thickness / 2
        #expect(abs((bottom - top) - thickness) < 0.0001)
    }

    @Test("Geometry scales linearly with the thickness")
    func geometryScalesLinearly() {
        let base = BrushRenderer.bands(forThickness: 25)
        let doubled = BrushRenderer.bands(forThickness: 50)
        for (a, b) in zip(base, doubled) {
            #expect(abs(b.offset - a.offset * 2) < 0.0001)
            #expect(abs(b.thickness - a.thickness * 2) < 0.0001)
        }
    }

    @Test("A zero thickness collapses every band to the axis")
    func zeroThickness() {
        #expect(BrushRenderer.bands(forThickness: 0).allSatisfy { $0 == .init(offset: 0, thickness: 0) })
    }

    // MARK: - drawStroke(_:in:)

    private func makeContext(_ side: Int = 100) -> CGContext {
        CGContext(
            data: nil,
            width: side,
            height: side,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpace(name: CGColorSpace.sRGB)!,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!
    }

    private func paintedPixelCount(_ context: CGContext) -> Int {
        guard let data = context.data else { return 0 }
        let total = context.bytesPerRow * context.height
        let bytes = data.bindMemory(to: UInt8.self, capacity: total)
        var painted = 0
        for i in stride(from: 3, to: total, by: 4) where bytes[i] != 0 { painted += 1 }
        return painted
    }

    @Test("Drawing a multi-point stroke leaves marks on the context")
    func drawingMarksContext() {
        let context = makeContext()
        let stroke = Stroke(
            points: [CGPoint(x: 10, y: 50), CGPoint(x: 90, y: 50)],
            brush: Brush(size: 20, opacity: 1)
        )
        BrushRenderer().drawStroke(stroke, in: context)
        #expect(paintedPixelCount(context) > 0)
    }

    @Test("A stroke of a single point draws nothing")
    func singlePointDrawsNothing() {
        let context = makeContext()
        BrushRenderer().drawStroke(
            Stroke(points: [CGPoint(x: 50, y: 50)], brush: .default),
            in: context
        )
        #expect(paintedPixelCount(context) == 0)
    }

    @Test("A fully transparent brush draws nothing visible")
    func transparentBrushDrawsNothing() {
        let context = makeContext()
        let stroke = Stroke(
            points: [CGPoint(x: 10, y: 50), CGPoint(x: 90, y: 50)],
            brush: Brush(size: 20, opacity: 0)
        )
        BrushRenderer().drawStroke(stroke, in: context)
        #expect(paintedPixelCount(context) == 0)
    }
}
