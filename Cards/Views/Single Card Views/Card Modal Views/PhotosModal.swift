// PhotosModal

// Created by Raymond Shelton on 9/22/24.

// This SwiftUI View allows users to select images from their photo library to add to a card.

import SwiftUI
import PhotosUI

struct PhotosModal: View {
  @Binding var card: Card // Binds to the card object where selected images will be added
  @State private var selectedItems: [PhotosPickerItem] = [] // Holds the user's selected photos

  var body: some View {
    // PhotosPicker lets users choose images from their library
    PhotosPicker(
      selection: $selectedItems, // Bind the selected items
      matching: .images) { // We're only interested in images
        ToolbarButton(modal: .photoModal) // Custom button for the toolbar
    }
    .onChange(of: selectedItems) { items in // Listen for changes to the selected items
      for item in items {
        // Load the image data from each selected item
        item.loadTransferable(type: Data.self) { result in
          Task {
            switch result {
            case .success(let data):
              // If we successfully load the data, convert it to a UIImage
              if let data,
                let uiImage = UIImage(data: data) {
                card.addElement(uiImage: uiImage) // Add the image to the card
              }
            case .failure(let failure):
              // If something goes wrong, we throw an error
              fatalError("Image transfer failed: \(failure)")
            }
          }
        }
      }
      selectedItems = [] // Clear the selected items after processing
    }
  }
}

// Preview for PhotosModal
struct PhotosModal_Previews: PreviewProvider {
  static var previews: some View {
    PhotosModal(card: .constant(Card())) // Provide a default Card for preview
  }
}
