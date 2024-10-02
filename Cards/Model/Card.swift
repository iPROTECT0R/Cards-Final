// Card

// Created by Raymond Shelton on 9/22/24.

// This struct represents a card with a background color and a collection of elements (images and text).

import SwiftUI
struct Card: Identifiable {
  var id = UUID() // Unique identifier for the card
  var backgroundColor: Color = .yellow // Default background color
  var elements: [CardElement] = [] // Holds all elements on the card

  // Adds an image element to the card at a specific offset
  mutating func addElement(uiImage: UIImage, at offset: CGSize = .zero) {
    let imageFilename = uiImage.save() // Save the image and get the filename
    let transform = Transform(offset: offset) // Create a transform for the image
    let element = ImageElement(
      transform: transform,
      uiImage: uiImage,
      imageFilename: imageFilename) // Create a new image element
    elements.append(element) // Add the element to the card
    save() // Save the updated card
  }

  // Adds a text element to the card
  mutating func addElement(text: TextElement) {
    elements.append(text) // Simply append the text element
  }

  // Adds multiple elements from a custom transfer
  mutating func addElements(from transfer: [CustomTransfer], at offset: CGSize) {
    for element in transfer {
      if let text = element.text {
        addElement(text: TextElement(text: text)) // Add text element
      } else if let image = element.image {
        addElement(uiImage: image, at: offset) // Add image element
      }
    }
  }

  // Removes a specified element from the card
  mutating func remove(_ element: CardElement) {
    if let element = element as? ImageElement {
      UIImage.remove(name: element.imageFilename) // Remove the image from storage
    }
    if let index = element.index(in: elements) {
      elements.remove(at: index) // Remove the element from the card
    }
    save() // Save the updated card
  }

  // Updates an element's frame index if it's an image
  mutating func update(_ element: CardElement?, frameIndex: Int) {
    if let element = element as? ImageElement,
       let index = element.index(in: elements) {
      var newElement = element // Create a mutable copy of the element
      newElement.frameIndex = frameIndex // Update the frame index
      elements[index] = newElement // Replace the old element with the updated one
    }
  }

  // Saves the card's data to disk
  func save() {
    do {
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted // For better readability
      let data = try encoder.encode(self) // Encode the card to JSON
      let filename = "\(id).rwcard" // Create a filename based on the card's ID
      let url = URL.documentsDirectory
        .appendingPathComponent(filename) // Create a URL for saving
      try data.write(to: url) // Write the data to disk
    } catch {
      print("Error saving card: ", error.localizedDescription) // Log any errors encountered
    }
  }
}

// Conformance to Codable to enable saving and loading
extension Card: Codable {
  enum CodingKeys: CodingKey {
    case id, backgroundColor, imageElements, textElements // Define keys for encoding/decoding
  }

  // Custom initializer for decoding from JSON
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let id = try container.decode(String.self, forKey: .id) // Decode the ID
    self.id = UUID(uuidString: id) ?? UUID() // Convert to UUID
    elements += try container.decode([ImageElement].self, forKey: .imageElements) // Decode image elements
    elements += try container.decode([TextElement].self, forKey: .textElements) // Decode text elements
    let components = try container.decode([CGFloat].self, forKey: .backgroundColor) // Decode color components
    backgroundColor = Color.color(components: components) // Create a Color from components
  }

  // Custom method for encoding to JSON
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id.uuidString, forKey: .id) // Encode the ID as a string
    let imageElements: [ImageElement] =
      elements.compactMap { $0 as? ImageElement } // Filter for image elements
    try container.encode(imageElements, forKey: .imageElements) // Encode image elements
    let textElements: [TextElement] =
      elements.compactMap { $0 as? TextElement } // Filter for text elements
    try container.encode(textElements, forKey: .textElements) // Encode text elements
    let components = backgroundColor.colorComponents() // Get color components
    try container.encode(components, forKey: .backgroundColor) // Encode color components
  }
}
