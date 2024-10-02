// CustomTransfer

// Created by Raymond Shelton on 9/22/24.

// A structure that represents a transferable object that can hold an image or text.

import SwiftUI
struct CustomTransfer: Transferable {
  var image: UIImage? // Optional image data
  var text: String? // Optional text data

  // Define how this structure can be transferred between different formats.
  public static var transferRepresentation: some TransferRepresentation {
    
    // Representation for importing image data.
    DataRepresentation(importedContentType: .image) { data in
      let image = UIImage(data: data) // Try to create a UIImage from the incoming data
        ?? UIImage(named: "error-image") // Fallback to a default error image if it fails
      return CustomTransfer(image: image) // Return a CustomTransfer with the image
    }

    // Representation for importing text data.
    DataRepresentation(importedContentType: .text) { data in
      let text = String(decoding: data, as: UTF8.self) // Decode the incoming data as a String
      return CustomTransfer(text: text) // Return a CustomTransfer with the text
    }
  }
}
