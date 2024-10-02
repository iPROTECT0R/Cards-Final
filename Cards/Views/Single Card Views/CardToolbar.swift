// CardToolbar

// Created by Raymond Shelton on 9/22/24.

// This ViewModifier adds a toolbar to the card editing interface, allowing users to perform actions such as sharing, adding elements, and dismissing the view.

import SwiftUI

struct CardToolbar: ViewModifier {
  @EnvironmentObject var store: CardStore // Access the card store for managing card data
  @Environment(\.dismiss) var dismiss // Dismiss action for the view
  @Binding var currentModal: ToolbarSelection? // Currently selected modal
  @Binding var card: Card // Binding to the current card being edited

  @State private var stickerImage: UIImage? // State for storing sticker image
  @State private var frameIndex: Int? // State for storing frame index
  @State private var textElement = TextElement() // State for new text element

  func body(content: Content) -> some View {
    content
      .toolbar {
        // Menu item for pasting elements
        ToolbarItem(placement: .navigationBarTrailing) {
          menu
        }

        // Done button to dismiss the card editor
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Done") {
            dismiss() // Action to dismiss the view
          }
        }

        // Share button to share the card as an image
        ToolbarItem(placement: .navigationBarLeading) {
          let uiImage = UIImage.screenshot(
            card: card,
            size: Settings.cardSize) // Take a screenshot of the card
          let image = Image(uiImage: uiImage)
          ShareLink(
            item: image,
            preview: SharePreview(
              "Card",
              image: image)) {
                Image(systemName: "square.and.arrow.up") // Share icon
          }
        }

        // Bottom toolbar for additional actions
        ToolbarItem(placement: .bottomBar) {
          BottomToolbar(
            card: $card,
            modal: $currentModal) // Embed the bottom toolbar
        }
      }
      .sheet(item: $currentModal) { item in
        // Present different modals based on the selected toolbar option
        switch item {
        case .frameModal:
          FrameModal(frameIndex: $frameIndex)
            .onDisappear {
              // Update the card with the selected frame when the modal is dismissed
              if let frameIndex {
                card.update(
                  store.selectedElement,
                  frameIndex: frameIndex)
              }
              frameIndex = nil
            }
        case .stickerModal:
          StickerModal(stickerImage: $stickerImage)
            .onDisappear {
              // Add the sticker to the card if one was selected
              if let stickerImage = stickerImage {
                card.addElement(uiImage: stickerImage)
              }
              stickerImage = nil
            }
        case .textModal:
          TextModal(textElement: $textElement)
            .onDisappear {
              // Add the text element to the card if it's not empty
              if !textElement.text.isEmpty {
                card.addElement(text: textElement)
              }
              textElement = TextElement() // Reset the text element for next use
            }
        default:
          Text(String(describing: item)) // Default case for other selections
        }
      }
  }

  // Menu for pasting elements from the clipboard
  var menu: some View {
    Menu {
      Button {
        // Check for images in the clipboard and add them to the card
        if UIPasteboard.general.hasImages {
          if let images = UIPasteboard.general.images {
            for image in images {
              card.addElement(uiImage: image)
            }
          }
        } else if UIPasteboard.general.hasStrings {
          // Check for strings in the clipboard and add them as text elements
          if let strings = UIPasteboard.general.strings {
            for text in strings {
              card.addElement(text: TextElement(text: text))
            }
          }
        }
      } label: {
        Label("Paste", systemImage: "doc.on.clipboard") // Paste label
      }
      .disabled(!UIPasteboard.general.hasImages
        && !UIPasteboard.general.hasStrings) // Disable if nothing to paste
    } label: {
      Label("Add", systemImage: "ellipsis.circle") // Add menu label
    }
  }
}
