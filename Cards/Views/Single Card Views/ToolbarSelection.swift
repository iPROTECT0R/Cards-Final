// ToolbarSelection

// Created by Raymond Shelton on 9/22/24.

// This enum represents the different modal options available in the toolbar. It conforms to CaseIterable for iteration and Identifiable for unique identification.

import Foundation

enum ToolbarSelection: CaseIterable, Identifiable {
  // Unique identifier for each case, using the hash value
  var id: Int {
    hashValue
  }

  // Different modal selections available in the toolbar
  case photoModal // For selecting photos
  case frameModal // For selecting frames
  case stickerModal // For selecting stickers
  case textModal // For adding text
}
