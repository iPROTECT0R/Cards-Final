// CardThumbnail

// Created by Raymond Shelton on 9/22/24.

// This view represents a thumbnail for a card. It displays the card's background color and applies a rounded corner and shadow effect.

import SwiftUI

struct CardThumbnail: View {
  let card: Card // The card object containing data for the thumbnail

  var body: some View {
    // Display the card's background color
    card.backgroundColor
      .cornerRadius(10) // Round the corners of the thumbnail
      .shadow(
        color: Color("shadow-color"), // Shadow color defined in asset catalog
        radius: 3, // Shadow radius
        x: 0.0, // Horizontal offset of the shadow
        y: 0.0) // Vertical offset of the shadow
  }
}

// Preview provider for displaying the CardThumbnail in the SwiftUI canvas
struct CardThumbnail_Previews: PreviewProvider {
  static var previews: some View {
    CardThumbnail(card: initialCards[0]) // Preview the thumbnail using the first card
      .frame(
        width: Settings.thumbnailSize.width, // Set width from settings
        height: Settings.thumbnailSize.height) // Set height from settings
  }
}
