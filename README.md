# BrushCore

## Description

**BrushCore** is a modular and reusable Swift Package that powers a colorful brush rendering engine for iOS drawing apps. It enables multi-layered, rainbow-style strokes using pure UIKit and Core Graphics. The package is lightweight, flexible, and ideal for creative prototyping or production-ready features in art-focused applications.

---

## Key Features

- Rainbow brush with 4 parallel color bands (red, yellow, green, blue)
- Smooth stroke rendering using Core Graphics
- Dynamic line thickness and opacity
- Designed as a standalone Swift Package
- Fully UIKit-compatible for integration into custom canvas views

---

## Installation

1. Clone or download the repository.
2. In your Xcode project:
    - Go to `File > Add Packages...`
    - Choose `Add Local...` and select the `BrushCore/Package.swift` file.
3. Import it in your code:
    
    ```swift
    import BrushCore
    ```
    

---

## Code Structure

```

BrushCoreDemoApp/
├── AppDelegate.swift
├── SceneDelegate.swift
├── ViewController.swift
├── CanvasView.swift
│
└── Package Dependencies/
    └── BrushCore/
        ├── Brush.swift
        ├── Stroke.swift
        ├── BrushRenderer.swift
        └── BrushSettings.swift
```

---

## Technologies Used

- Swift
- UIKit
- Core Graphics
- Swift Package Manager

---

## Project Goal

This mini project was built to explore creative rendering techniques in iOS, particularly for artistic and educational use cases. The goal was to create a clean, reusable foundation for more advanced brush tools and stylus-based drawing experiences all while showcasing the power of modular Swift architecture.

---

## License

This project is licensed under the **MIT License**.
