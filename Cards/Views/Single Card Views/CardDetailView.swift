// CardDetailView

// Created by Raymond Shelton on 9/22/24.

// This view displays the details of a card, allowing interaction with its elements. Users can select elements, add new ones, and manage their positioning.

import SwiftUI

struct CardDetailView: View {
  @EnvironmentObject var store: CardStore // Access to the shared CardStore
  @Binding var card: Card // Binding to the card data being displayed
  var viewScale: CGFloat = 1 // Scale factor for the view
  var proxy: GeometryProxy? // Optional proxy for layout calculations

  // Check if a specific element is currently selected
  func isSelected(_ element: CardElement) -> Bool {
    store.selectedElement?.id == element.id
  }

  var body: some View {
    ZStack {
      // Background color of the card
      card.backgroundColor
        .onTapGesture {
          // Deselect any currently selected element when tapping the background
          store.selectedElement = nil
        }
      
      // Iterate over card elements and display them
      ForEach($card.elements, id: \.id) { $element in
        CardElementView(element: element) // Display the individual card element
          .overlay(
            element: element, // Overlay decorations
            isSelected: isSelected(element)) // Check if the element is selected
          .elementContextMenu(
            card: $card, // Provide a context menu for element actions
            element: $element) // Pass the element for specific actions
          .resizableView(
            transform: $element.transform, // Allow resizing and transforming of the element
            viewScale: viewScale) // Pass the current view scale
          .frame(
            width: element.transform.size.width, // Set width based on element transform
            height: element.transform.size.height) // Set height based on element transform
          .onTapGesture {
            // Select the tapped element
            store.selectedElement = element
          }
      }
    }
    .onDisappear {
      // Clear the selected element when the view disappears
      store.selectedElement = nil
    }
    .dropDestination(for: CustomTransfer.self) { items, location in
      // Handle dropping items onto the card
      let offset = Settings.calculateDropOffset(
        proxy: proxy,
        location: location) // Calculate the drop offset based on location
      Task {
        // Add elements from the dropped items at the calculated offset
        card.addElements(from: items, at: offset)
      }
      return !items.isEmpty // Indicate that the drop was successful if there are items
    }
  }
}

// Preview provider for displaying the CardDetailView in the SwiftUI canvas
struct CardDetailView_Previews: PreviewProvider {
  struct CardDetailPreview: View {
    @EnvironmentObject var store: CardStore // Access to the shared CardStore

    var body: some View {
      CardDetailView(card: $store.cards[0]) // Preview the first card in the store
    }
  }

  static var previews: some View {
    CardDetailPreview()
      .environmentObject(CardStore(defaultData: true)) // Provide mock CardStore for previews
  }
}

// Extension for adding overlay effects based on selection state
private extension View {
  @ViewBuilder
  func overlay(
    element: CardElement, // The element for which to draw the overlay
    isSelected: Bool // Whether the element is selected
  ) -> some View {
    if isSelected,
      let element = element as? ImageElement, // Check if the element is an ImageElement
      let frameIndex = element.frameIndex {
      let shape = Shapes.shapes[frameIndex] // Get the corresponding shape from Shapes
      // Apply an overlay with stroke for the selected image element
      self.overlay(shape
        .stroke(lineWidth: Settings.borderWidth)
        .foregroundColor(Settings.borderColor))
    } else {
      // Apply a border if the element is selected
      self
        .border(
          Settings.borderColor,
          width: isSelected ? Settings.borderWidth : 0) // Show border based on selection
    }
  }
}
