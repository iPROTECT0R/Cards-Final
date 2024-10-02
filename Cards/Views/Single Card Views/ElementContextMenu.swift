// ElementContextMenu

// Created by Raymond Shelton on 9/22/24.

// This view modifier adds a context menu to card elements, allowing users to copy text or images to the clipboard or delete the element from the card.

import SwiftUI

struct ElementContextMenu: ViewModifier {
  @Binding var card: Card // Binding to the card that contains the element
  @Binding var element: CardElement // Binding to the specific card element

  func body(content: Content) -> some View {
    content
      .contextMenu { // Define the context menu for the element
        // Copy action for text or image elements
        Button {
          // Check if the element is a TextElement
          if let element = element as? TextElement {
            UIPasteboard.general.string = element.text // Copy the text to clipboard
          } else if let element = element as? ImageElement,
                    let image = element.uiImage {
            UIPasteboard.general.image = image // Copy the image to clipboard
          }
        } label: {
          Label("Copy", systemImage: "doc.on.doc") // Label for the copy action
        }
        
        // Delete action for the element
        Button(role: .destructive) {
          card.remove(element) // Remove the element from the card
        } label: {
          Label("Delete", systemImage: "trash") // Label for the delete action
        }
      }
  }
}

// Extension to simplify applying the context menu modifier
extension View {
  func elementContextMenu(
    card: Binding<Card>, // Binding to the card
    element: Binding<CardElement> // Binding to the specific element
  ) -> some View {
    modifier(ElementContextMenu(
      card: card,
      element: element)) // Apply the context menu modifier
  }
}
