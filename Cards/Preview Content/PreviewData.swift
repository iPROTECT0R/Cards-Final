// PreviewData

// Created by Raymond Shelton on 9/22/24.

// This file contains the initial setup for cards and their elements.

import SwiftUI
let initialCards: [Card] = [
    Card(backgroundColor: Color("random1"), elements: initialElements), // First card with elements
    Card(backgroundColor: Color("random2")), // Second card without elements
    Card(backgroundColor: Color("random3")), // Third card without elements
    Card(backgroundColor: Color("random4")), // Fourth card without elements
    Card(backgroundColor: Color("random8"))  // Fifth card without elements
]

let initialElements: [CardElement] = [
    ImageElement(
        transform: Transform(
            size: Settings.defaultElementSize * 0.9, // Size of the image element
            rotation: .init(degrees: -6), // Rotation angle
            offset: CGSize(width: 4, height: -137) // Offset position
        ),
        uiImage: UIImage(named: "giraffe1") // Image to be displayed
    ),
    TextElement(
        transform: Transform(
            size: CGSize(width: 600, height: 300), // Size of the text element
            offset: CGSize(width: 12, height: 400) // Offset position
        ),
        text: "Snack time!", // Text to be displayed
        textColor: .blue // Color of the text
    )
]
