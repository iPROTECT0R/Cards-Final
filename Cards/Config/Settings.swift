// Settings

// Created by Raymond Shelton on 9/22/24.

// This module contains configuration settings for the application, including sizes, colors, and functions for size calculations.

import SwiftUI

enum Settings {
    static let cardSize = CGSize(width: 1300, height: 2000) // Default card size
    static let thumbnailSize = CGSize(width: 150, height: 250) // Thumbnail size for previews
    static let defaultElementSize = CGSize(width: 800, height: 800) // Default size for card elements
    static let borderColor: Color = .blue // Default border color for cards
    static let borderWidth: CGFloat = 5 // Default border width for cards

    // Calculates a new size while maintaining the aspect ratio based on the card size
    static func calculateSize(_ size: CGSize) -> CGSize {
        var newSize = size
        let ratio = Settings.cardSize.width / Settings.cardSize.height

        if size.width < size.height {
            newSize.height = min(size.height, newSize.width / ratio)
            newSize.width = min(size.width, newSize.height * ratio)
        } else {
            newSize.width = min(size.width, newSize.height * ratio)
            newSize.height = min(size.height, newSize.width / ratio)
        }
        return newSize
    }

    // Calculates the scale factor relative to the default card size
    static func calculateScale(_ size: CGSize) -> CGFloat {
        let newSize = calculateSize(size)
        return newSize.width / Settings.cardSize.width
    }
}

extension Settings {
    // Calculates the offset for drag and drop functionality based on the screen location
    static func calculateDropOffset(
        proxy: GeometryProxy?,
        location: CGPoint
    ) -> CGSize {
        guard
            let proxy,
            proxy.size.width > 0 && proxy.size.height > 0
        else { return .zero }

        let frame = proxy.frame(in: .global)

        // Size is the calculated card size without margins
        let size = proxy.size

        // Margins are the frame around the card plus the frame's origin, if inset
        let leftMargin = (frame.width - size.width) * 0.5 + frame.origin.x
        let topMargin = (frame.height - size.height) * 0.5 + frame.origin.y

        // Convert location from screen space to card space
        var cardLocation = CGPoint(x: location.x - leftMargin, y: location.y - topMargin)

        // Convert cardLocation into the fixed card coordinate space
        // so that the location is in 1300 x 2000 space
        cardLocation.x = cardLocation.x / size.width * Settings.cardSize.width
        cardLocation.y = cardLocation.y / size.height * Settings.cardSize.height

        // Calculate the offset where (0, 0) is at the center of the card
        let offset = CGSize(
            width: cardLocation.x - Settings.cardSize.width * 0.5,
            height: cardLocation.y - Settings.cardSize.height * 0.5
        )
        return offset
    }
}
