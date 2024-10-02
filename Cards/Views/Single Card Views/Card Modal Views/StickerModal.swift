// StickerModal

// Created by Raymond Shelton on 9/22/24.

// This SwiftUI View displays a modal for selecting stickers from a specified resource folder.

import SwiftUI

struct StickerModal: View {
  @Environment(\.dismiss) var dismiss // This allows us to dismiss the modal
  @Binding var stickerImage: UIImage? // Binds to the selected sticker image
  @State private var stickerNames: [String] = [] // State to hold the names of stickers
  let columns = [
    GridItem(.adaptive(minimum: 120), spacing: 10) // Creates a grid layout for the stickers
  ]

  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns) { // Efficiently loads stickers in a grid
        ForEach(stickerNames, id: \.self) { sticker in
          Image(uiImage: image(from: sticker)) // Load and display each sticker image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .onTapGesture {
              stickerImage = image(from: sticker) // Set the selected sticker image
              dismiss() // Close the modal
            }
        }
      }
    }
    .onAppear {
      stickerNames = Self.loadStickers() // Load sticker names when the view appears
    }
  }

  // This function loads stickers from the app bundle
  static func loadStickers() -> [String] {
    var themes: [URL] = [] // Array to hold theme directories
    var stickerNames: [String] = [] // Array to hold sticker file names
    let fileManager = FileManager.default // File manager to access the file system

    // Get the resource path and look for directories with stickers
    if let resourcePath = Bundle.main.resourcePath,
      let enumerator = fileManager.enumerator(
        at: URL(fileURLWithPath: resourcePath + "/Stickers"),
        includingPropertiesForKeys: nil,
        options: [
          .skipsSubdirectoryDescendants,
          .skipsHiddenFiles
        ]) {
          for case let url as URL in enumerator
          where url.hasDirectoryPath {
            themes.append(url) // Collect the paths of sticker directories
          }
    }

    // Now, we gather sticker files from each theme
    for theme in themes {
      if let files = try? fileManager.contentsOfDirectory(atPath: theme.path) {
        for file in files {
          stickerNames.append(theme.path + "/" + file) // Add the full path of each sticker
        }
      }
    }
    return stickerNames // Return the list of sticker names
  }

  // This function creates a UIImage from a given path
  func image(from path: String) -> UIImage {
    UIImage(named: path) // Try to load the image
      ?? UIImage(named: "error-image") // If it fails, use a default error image
      ?? UIImage() // Return an empty image if all else fails
  }
}

// Preview for StickerModal
struct StickerModal_Previews: PreviewProvider {
  static var previews: some View {
    StickerModal(stickerImage: .constant(UIImage())) // Show a default UIImage for preview
  }
}
