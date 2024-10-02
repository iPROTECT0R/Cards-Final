// TextModal

// Created by Raymond Shelton on 9/22/24.

// This SwiftUI View displays a modal for entering text to be added as a TextElement.

import SwiftUI
struct TextModal: View {
  @Environment(\.dismiss) var dismiss // This allows us to close the modal
  @Binding var textElement: TextElement // Binds to the TextElement being edited

  var body: some View {
    let onCommit = {
      dismiss() // Dismiss the modal when the user presses return
    }
    
    TextField(
      "Enter text", // Placeholder text for the text field
      text: $textElement.text, // Bind the text field to the text property of the TextElement
      onCommit: onCommit // Call onCommit when the text field editing is complete
    )
    .padding(20) // Add padding for better spacing
  }
}

// Preview for TextModal
struct TextModal_Previews: PreviewProvider {
  static var previews: some View {
    TextModal(textElement: .constant(TextElement())) // Show a default TextElement for preview
  }
}
