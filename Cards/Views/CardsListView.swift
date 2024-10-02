// CardsListView

// Created by Raymond Shelton on 9/22/24.

// This view displays a list of cards in either a grid or carousel format. It allows users to create, view, and delete cards, with a responsive layout.

import SwiftUI

struct CardsListView: View {
  @EnvironmentObject var store: CardStore // Access the shared CardStore
  @Environment(\.scenePhase) private var scenePhase // Track the app's scene phase
  @Environment(\.horizontalSizeClass) var horizontalSizeClass // Detect horizontal size class
  @Environment(\.verticalSizeClass) var verticalSizeClass // Detect vertical size class
  @State private var selectedCard: Card? // Keep track of the selected card
  @State private var listState = ListState.list // Control the display state (list or carousel)

  // Calculate the thumbnail size based on device size classes
  var thumbnailSize: CGSize {
    var scale: CGFloat = 1
    if verticalSizeClass == .regular,
       horizontalSizeClass == .regular {
      scale = 1.5 // Scale up for regular size classes
    }
    return Settings.thumbnailSize * scale // Return scaled thumbnail size
  }

  // Define the layout for the grid of cards
  var columns: [GridItem] {
    [
      GridItem(.adaptive(
        minimum: thumbnailSize.width)) // Adaptive grid item size
    ]
  }

  var body: some View {
    VStack {
      ListSelection(listState: $listState) // Display selection control (list or carousel)
      Group {
        // Check if there are cards in the store
        if store.cards.isEmpty {
          initialView // Show initial view if no cards are available
        } else {
          Group {
            // Display cards based on the selected list state
            switch listState {
            case .list:
              list // Show the list of cards
            case .carousel:
              Carousel(selectedCard: $selectedCard) // Show carousel view
            }
          }
        }
      }
      // Full-screen cover for displaying a selected card
      .fullScreenCover(item: $selectedCard) { card in
        if let index = store.index(for: card) {
          SingleCardView(card: $store.cards[index]) // Show detailed view for the selected card
            .onChange(of: scenePhase) { newScenePhase in
              // Save card data when the app goes inactive
              if newScenePhase == .inactive {
                store.cards[index].save()
              }
            }
        } else {
          fatalError("Unable to locate selected card") // Handle error if card is not found
        }
      }
      createButton // Button to create a new card
    }
    .background(
      Color("background") // Set background color
        .ignoresSafeArea())
  }

  // View displayed when there are no cards
  var initialView: some View {
    VStack {
      Spacer()
      let card = Card(
        backgroundColor: Color(uiColor: .systemBackground)) // Create a placeholder card
      ZStack {
        CardThumbnail(card: card) // Display thumbnail for the placeholder card
        Image(systemName: "plus.circle.fill") // Plus icon to indicate card creation
          .font(.largeTitle)
      }
      .frame(
        width: thumbnailSize.width * 1.2,
        height: thumbnailSize.height * 1.2) // Adjust frame size for visibility
      .onTapGesture {
        selectedCard = store.addCard() // Add a new card when tapped
      }
      Spacer()
    }
  }

  // View displaying the list of cards
  var list: some View {
    ScrollView(showsIndicators: false) { // Scrollable view for the card list
      LazyVGrid(columns: columns, spacing: 30) { // Grid layout for cards
        ForEach(store.cards) { card in
          CardThumbnail(card: card) // Display each card's thumbnail
            .contextMenu {
              Button(role: .destructive) {
                store.remove(card) // Allow card deletion from context menu
              } label: {
                Label("Delete", systemImage: "trash") // Delete label
              }
            }
            .frame(
              width: thumbnailSize.width,
              height: thumbnailSize.height) // Set frame for each thumbnail
            .onTapGesture {
              selectedCard = card // Set the selected card on tap
            }
        }
      }
    }
    .padding(.top, 20) // Add padding to the top
  }

  // Button for creating a new card
  var createButton: some View {
    Button {
      selectedCard = store.addCard() // Add a new card when tapped
    } label: {
      Label("Create New", systemImage: "plus") // Button label
        .frame(maxWidth: .infinity) // Make button fill the width
    }
    .font(.system(size: 16, weight: .bold)) // Set font style
    .padding([.top, .bottom], 10) // Add vertical padding
    .background(Color("barColor")) // Set button background color
    .accentColor(.white) // Set text color to white
  }
}

// Preview provider for displaying the CardsListView in the SwiftUI canvas
struct CardsListView_Previews: PreviewProvider {
  static var previews: some View {
    CardsListView()
      .environmentObject(CardStore(defaultData: true)) // Provide mock CardStore for previews
  }
}
