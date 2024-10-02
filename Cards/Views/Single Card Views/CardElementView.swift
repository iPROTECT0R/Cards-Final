// CardElementView

// Created by Raymond Shelton on 9/22/24.

// This view is responsible for displaying different types of card elements, such as images and text, based on their respective data types.

import SwiftUI

struct CardElementView: View {
  let element: CardElement // The card element to be displayed

  var body: some View {
    // Check the type of the element and render accordingly
    if let element = element as? ImageElement {
      ImageElementView(element: element) // Display image element
        .clip() // Apply clipping if necessary
    }
    if let element = element as? TextElement {
      TextElementView(element: element) // Display text element
    }
  }
}

// View for displaying image elements
struct ImageElementView: View {
  let element: ImageElement // The image element data

  var body: some View {
    element.image // Display the image
      .resizable() // Allow the image to be resized
      .aspectRatio(contentMode: .fit) // Maintain aspect ratio
  }
}

// View for displaying text elements
struct TextElementView: View {
  let element: TextElement // The text element data

  var body: some View {
    // Render the text only if it is not empty
    if !element.text.isEmpty {
      Text(element.text) // Display the text
        .font(.custom(element.textFont, size: 200)) // Use custom font and size
        .foregroundColor(element.textColor) // Set the text color
        .scalableText() // Apply any additional text scaling
    }
  }
}

// Preview provider for displaying the CardElementView in the SwiftUI canvas
struct CardElementView_Previews: PreviewProvider {
  static var previews: some View {
    CardElementView(element: initialElements[0]) // Preview the first element
  }
}

// Extension to handle clipping for image elements
private extension ImageElementView {
  @ViewBuilder
  func clip() -> some View {
    // Clip the image to a specific shape if a frame index exists
    if let frameIndex = element.frameIndex {
      let shape = Shapes.shapes[frameIndex] // Get the corresponding shape
      self
        .clipShape(shape) // Clip the view to the shape
        .contentShape(shape) // Set the content shape for hit testing
    } else {
      self // Return the original view if no clipping is required
    }
  }
}
