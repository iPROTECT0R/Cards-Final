// ColorExtensions

// Created by Raymond Shelton on 9/22/24.

// This extension adds functionality for random colors and color component manipulation.

import SwiftUI
extension Color {
    // Predefined random colors
    static let randomColors: [Color] = [
        Color("random1"),
        Color("random2"),
        Color("random3"),
        Color("random4"),
        Color("random5"),
        Color("random6"),
        Color("random7"),
        Color("random8")
    ]

    // Returns a random color from the predefined list
    static func random() -> Color {
        randomColors.randomElement() ?? .black
    }
}

extension Color {
    // Returns the RGBA components of the color
    func colorComponents() -> [CGFloat] {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getRed(
            &red,
            green: &green,
            blue: &blue,
            alpha: &alpha)
        return [red, green, blue, alpha]
    }

    // Creates a Color from an array of RGBA components
    static func color(components color: [CGFloat]) -> Color {
        let uiColor = UIColor(
            red: color[0],
            green: color[1],
            blue: color[2],
            alpha: color[3])
        return Color(uiColor)
    }
}
