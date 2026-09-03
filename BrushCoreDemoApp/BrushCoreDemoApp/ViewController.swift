//
//  ViewController.swift
//  BrushCoreDemoApp
//
//  Created by Stephano Portella on 24/05/25.
//

import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let canvas = CanvasView(frame: view.bounds)
        canvas.backgroundColor = .white
        canvas.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(canvas)
    }
}
