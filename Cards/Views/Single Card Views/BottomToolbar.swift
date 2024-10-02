// BottomToolbar

// Created by Raymond Shelton on 9/22/24.

// This view represents a button in the toolbar, displaying an image and corresponding text based on the selected modal type.

import SwiftUI

struct ToolbarButton: View {
  @Environment(\.verticalSizeClass) var verticalSizeClass // Environment variable for size class
  let modal: ToolbarSelection // The type of modal associated with this button

  // Dictionary mapping each modal to its text and image
  private let modalButton: [
    ToolbarSelection: (text: String, imageName: String)
  ] = [
    .photoModal: ("Photos", "photo"),
    .frameModal: ("Frames", "square.on.circle"),
    .stickerModal: ("Stickers", "heart.circle"),
    .textModal: ("Text", "textformat")
  ]

  var body: some View {
    // Retrieve text and image based on the modal
    if let text = modalButton[modal]?.text,
       let imageName = modalButton[modal]?.imageName {
      // Choose view style based on vertical size class
      if verticalSizeClass == .compact {
        compactView(imageName) // For compact view
      } else {
        regularView(imageName, text) // For regular view
      }
    }
  }

  // Regular view with text and image
  func regularView(_ imageName: String, _ text: String) -> some View {
    VStack(spacing: 2) {
      Image(systemName: imageName) // Display the image
      Text(text) // Display the text
    }
    .frame(minWidth: 60)
    .padding(.top, 5) // Add padding
  }

  // Compact view with only the image
  func compactView(_ imageName: String) -> some View {
    VStack(spacing: 2) {
      Image(systemName: imageName) // Display the image
    }
    .frame(minWidth: 60)
    .padding(.top, 5) // Add padding
  }
}

struct BottomToolbar: View {
  @EnvironmentObject var store: CardStore // Access the card store
  @Binding var card: Card // Binding to the current card
  @Binding var modal: ToolbarSelection? // Binding to the currently selected modal

  var body: some View {
    HStack(alignment: .bottom) {
      // Iterate through all possible toolbar selections
      ForEach(ToolbarSelection.allCases) { selection in
        switch selection {
        case .photoModal:
          // Button for the photo modal
          Button {
            // Action for opening photo modal can be defined here
          } label: {
            PhotosModal(card: $card) // Display photo modal
          }
        case .frameModal:
          // Button for frame modal, disabled if no selected image element
          defaultButton(selection)
            .disabled(
              store.selectedElement == nil
              || !(store.selectedElement is ImageElement))
        default:
          // Default button for other selections
          defaultButton(selection)
        }
      }
    }
  }

  // Create a default button for the toolbar
  func defaultButton(_ selection: ToolbarSelection) -> some View {
    Button {
      modal = selection // Set the current modal
    } label: {
      ToolbarButton(modal: selection) // Display the toolbar button
    }
  }
}

// Preview provider for the BottomToolbar
struct BottomToolbar_Previews: PreviewProvider {
  static var previews: some View {
    BottomToolbar(
      card: .constant(Card()), // Preview with a default card
      modal: .constant(.stickerModal)) // Preview with sticker modal selected
      .padding() // Add padding around the toolbar
      .environmentObject(CardStore()) // Provide a card store environment
  }
}
