// SingleCardView

// Created by Raymond Shelton on 9/22/24.

// This view displays the details of a single card. It provides a detailed view with a toolbar for editing and managing the card.

import SwiftUI

struct SingleCardView: View {
  @Binding var card: Card // Binding to the card data being displayed
  @State private var currentModal: ToolbarSelection? // State to track the currently selected modal from the toolbar

  var body: some View {
    NavigationStack { // Use a navigation stack for managing view hierarchy
      GeometryReader { proxy in // Proxy to access the size of the parent view
        CardDetailView(
          card: $card, // Bind the card to the detail view
          viewScale: Settings.calculateScale(proxy.size), // Calculate the scale based on available size
          proxy: proxy) // Pass the proxy for layout purposes
          .frame(
            width: Settings.calculateSize(proxy.size).width, // Set width based on calculated size
            height: Settings.calculateSize(proxy.size).height) // Set height based on calculated size
          .clipped() // Clip any overflowing content
          .frame(maxWidth: .infinity, maxHeight: .infinity) // Allow the view to expand to fill available space
          .modifier(CardToolbar(
            currentModal: $currentModal, // Pass the current modal state to the toolbar
            card: $card)) // Bind the card to the toolbar for edits
          .onDisappear {
            card.save() // Save the card data when the view disappears
          }
      }
    }
  }
}

// Preview provider for displaying the SingleCardView in the SwiftUI canvas
struct SingleCardView_Previews: PreviewProvider {
  struct SingleCardPreview: View {
    @EnvironmentObject var store: CardStore // Access the shared CardStore for previewing

    var body: some View {
      SingleCardView(card: $store.cards[0]) // Preview the first card in the store
    }
  }

  static var previews: some View {
    SingleCardPreview()
      .environmentObject(CardStore(defaultData: true)) // Provide mock CardStore for previews
  }
}
