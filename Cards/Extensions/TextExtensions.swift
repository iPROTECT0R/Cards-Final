// TextExtensions

// Created by Raymond Shelton on 9/22/24.

// This extension adds a scalable text modifier for dynamic resizing.

import SwiftUI
extension Text {
    // Returns a scalable text view with a default font size
    func scalableText(font: Font = Font.system(size: 1000)) -> some View {
        self
            .font(font)
            .minimumScaleFactor(0.01) // Sets the minimum scale factor
            .lineLimit(1) // Limits the text to a single line
    }
}
