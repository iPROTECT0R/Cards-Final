// CardElement

// Created by Raymond Shelton on 9/22/24.

// This protocol defines the basic structure for elements that can be added to a card.

import SwiftUI
protocol CardElement {
  var id: UUID { get } // Each element has a unique identifier
  var transform: Transform { get set } // Transformation properties (like position)
}

// Default implementation to find the index of the element in an array
extension CardElement {
  func index(in array: [CardElement]) -> Int? {
    array.firstIndex { $0.id == id } // Look for the element with the same ID
  }
}

// ImageElement Struct
// Represents an image element on the card.
struct ImageElement: CardElement {
  let id = UUID() // Unique identifier for the image
  var transform = Transform() // Transformation properties
  var frameIndex: Int? // Index for the frame style
  var uiImage: UIImage? // The image itself
  var imageFilename: String? // Filename for saving/loading the image

  // This computed property returns the image to be displayed
  var image: Image {
    Image(
      uiImage: uiImage ??
        UIImage(named: "error-image") ??
        UIImage()) // Fallback to an error image if none is available
  }
}

// Conformance to Codable for saving/loading
extension ImageElement: Codable {
  enum CodingKeys: CodingKey {
    case transform, imageFilename, frameIndex // Keys for encoding/decoding
  }

  // Initializer for decoding from JSON
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    transform = try container.decode(Transform.self, forKey: .transform) // Decode transform
    frameIndex = try container.decodeIfPresent(Int.self, forKey: .frameIndex) // Optional frame index
    imageFilename = try container.decodeIfPresent(String.self, forKey: .imageFilename) // Optional filename
    if let imageFilename {
      uiImage = UIImage.load(uuidString: imageFilename) // Load the image if the filename exists
    } else {
      uiImage = UIImage.errorImage // Fallback to a default error image
    }
  }

  // Method for encoding to JSON
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(transform, forKey: .transform) // Encode transform
    try container.encode(frameIndex, forKey: .frameIndex) // Encode frame index
    try container.encode(imageFilename, forKey: .imageFilename) // Encode image filename
  }
}

// TextElement Struct
// Represents a text element on the card.
struct TextElement: CardElement {
  let id = UUID() // Unique identifier for the text
  var transform = Transform() // Transformation properties
  var text = "" // The text content
  var textColor = Color.black // Default text color
  var textFont = "Gill Sans" // Default text font
}

// Conformance to Codable for saving/loading
extension TextElement: Codable {
  enum CodingKeys: CodingKey {
    case transform, text, textColor, textFont // Keys for encoding/decoding
  }

  // Initializer for decoding from JSON
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    transform = try container.decode(Transform.self, forKey: .transform) // Decode transform
    text = try container.decode(String.self, forKey: .text) // Decode text content
    let components = try container.decode([CGFloat].self, forKey: .textColor) // Decode color components
    textColor = Color.color(components: components) // Create a Color from components
    textFont = try container.decode(String.self, forKey: .textFont) // Decode font
  }

  // Method for encoding to JSON
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(transform, forKey: .transform) // Encode transform
    try container.encode(text, forKey: .text) // Encode text content
    let components = textColor.colorComponents() // Get color components
    try container.encode(components, forKey: .textColor) // Encode color components
    try container.encode(textFont, forKey: .textFont) // Encode font
  }
}
