//
//  ViewController.swift
//  BrushCoreDemoApp
//
//  Created by Stephano Portella on 24/05/25.
//

import UIKit
import BrushCore

final class ViewController: UIViewController {

    // Rango de grosor que ofrece el slider de la demo.
    private let sizeRange: ClosedRange<Float> = 10...80

    private let canvas = CanvasView()
    private let sizeSlider = UISlider()
    private let clearButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        canvas.backgroundColor = .white
        canvas.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(canvas)

        sizeSlider.minimumValue = sizeRange.lowerBound
        sizeSlider.maximumValue = sizeRange.upperBound
        sizeSlider.value = Float(canvas.brush.size)
        sizeSlider.addTarget(self, action: #selector(sizeChanged), for: .valueChanged)
        sizeSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sizeSlider)

        clearButton.configuration = {
            var config = UIButton.Configuration.bordered()
            config.title = "Borrar"
            return config
        }()
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clearButton)

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            canvas.topAnchor.constraint(equalTo: view.topAnchor),
            canvas.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            canvas.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            canvas.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            sizeSlider.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            sizeSlider.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16),
            sizeSlider.widthAnchor.constraint(equalToConstant: 160),

            clearButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            clearButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16)
        ])
    }

    @objc private func sizeChanged() {
        canvas.brush.size = CGFloat(sizeSlider.value)
    }

    @objc private func clearTapped() {
        canvas.clear()
    }
}
