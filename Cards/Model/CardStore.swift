// CardStore

// Created by Raymond Shelton on 9/22/24.

// This class manages a collection of Card objects and handles operations like adding, removing, and loading cards.

import SwiftUI
class CardStore: ObservableObject {
  @Published var cards: [Card] = [] // Holds the collection of cards
  @Published var selectedElement: CardElement? // Tracks the currently selected card element

  // Initializer that optionally loads default data
  init(defaultData: Bool = false) {
    cards = defaultData ? initialCards : load() // Load initial cards if requested, otherwise load from storage
  }

  // Finds the index of a given card in the collection
  func index(for card: Card) -> Int? {
    cards.firstIndex { $0.id == card.id } // Returns the index or nil if not found
  }

  // Removes a card and its associated elements from the store
  func remove(_ card: Card) {
    guard let index = index(for: card) else { return } // Ensure the card exists
    // Remove each element associated with the card
    for element in cards[index].elements {
      cards[index].remove(element) // Clean up element resources
    }
    // Remove the card image from disk
    UIImage.remove(name: card.id.uuidString)
    // Remove card details from the file system
    let path = URL.documentsDirectory
      .appendingPathComponent("\(card.id.uuidString).rwcard")
    try? FileManager.default.removeItem(at: path) // Ignore errors for now
    cards.remove(at: index) // Finally, remove the card from the collection
  }

  // Adds a new card with a random background color to the store
  func addCard() -> Card {
    let card = Card(backgroundColor: Color.random()) // Create a new card with a random background
    cards.append(card) // Add the new card to the collection
    card.save() // Save the new card to storage
    return card // Return the newly created card
  }
}

// Extension to handle loading cards from the file system
extension CardStore {
  // Loads cards from the documents directory
  func load() -> [Card] {
    var cards: [Card] = [] // Array to hold loaded cards
    let path = URL.documentsDirectory.path // Get the path to the documents directory
    guard
      let enumerator = FileManager.default
        .enumerator(atPath: path), // Enumerate files in the directory
      let files = enumerator.allObjects as? [String]
    else { return cards } // Return empty if unable to enumerate
    let cardFiles = files.filter { $0.contains(".rwcard") } // Filter for card files
    for cardFile in cardFiles {
      do {
        let path = path + "/" + cardFile // Construct the full path
        let data = try Data(contentsOf: URL(fileURLWithPath: path)) // Load the card data
        let decoder = JSONDecoder()
        let card = try decoder.decode(Card.self, from: data) // Decode the card
        cards.append(card) // Add the card to the collection
      } catch {
        print("Error loading card: ", error.localizedDescription) // Log any errors encountered
      }
    }
    return cards // Return the array of loaded cards
  }
}
