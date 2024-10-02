// FrameModal

// Created by Raymond Shelton on 9/22/24.

// This SwiftUI View displays a modal for selecting frames from a predefined set of shapes.

import SwiftUI
struct FrameModal: View {
  @Environment(\.dismiss) var dismiss // This allows us to close the modal
  @Binding var frameIndex: Int? // Binds to the selected frame index

  private let columns = [
    GridItem(.adaptive(minimum: 120), spacing: 10) // Creates a grid layout for displaying frames
  ]
  private let style = StrokeStyle(
    lineWidth: 5, // Sets the line width for the frame stroke
    lineJoin: .round // Sets the line join style for rounded corners
  )

  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns) { // Efficiently loads frames in a grid
        ForEach(0..<Shapes.shapes.count, id: \.self) { index in
          Shapes.shapes[index]
            .stroke(Color.primary, style: style) // Stroke the shape with the primary color
            .background(
              Shapes.shapes[index].fill(Color.secondary) // Fill the shape with a secondary color
            )
            .frame(width: 100, height: 120) // Set the frame size for each shape
            .padding() // Add some padding around each shape
            .onTapGesture {
              frameIndex = index // Update the selected frame index
              dismiss() // Close the modal
            }
        }
      }
    }
    .padding(5) // Add padding to the scroll view
  }
}

// Preview for FrameModal
struct FrameModal_Previews: PreviewProvider {
  static var previews: some View {
    FrameModal(frameIndex: .constant(nil)) // Provide a default value for preview
  }
}
