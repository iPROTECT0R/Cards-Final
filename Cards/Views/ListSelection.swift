// ListSelection

// Created by Raymond Shelton on 9/22/24.

// This view allows users to toggle between different display states for the card list. It provides a segmented picker for switching between a grid and carousel view.

import SwiftUI

enum ListState {
  case list, carousel // Enum to represent the two display states
}

struct ListSelection: View {
  @Binding var listState: ListState // Binding to the current list state

  var body: some View {
    // Picker for selecting the list display mode
    Picker(selection: $listState, label: Text("")) {
      // Icon for the grid view
      Image(systemName: "square.grid.2x2.fill")
        .tag(ListState.list) // Tag for grid view state
      // Icon for the carousel view
      Image(systemName: "rectangle.stack.fill")
        .tag(ListState.carousel) // Tag for carousel view state
    }
    .pickerStyle(.segmented) // Use a segmented style for the picker
    .frame(width: 200) // Set the width of the picker
  }
}

// Preview provider for displaying the ListSelection in the SwiftUI canvas
struct ListSelection_Previews: PreviewProvider {
  static var previews: some View {
    ListSelection(listState: .constant(.list)) // Preview with list state selected
  }
}
