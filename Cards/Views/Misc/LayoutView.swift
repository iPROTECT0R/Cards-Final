// LayoutView

// Created by Raymond Shelton on 9/22/24.

// This SwiftUI View demonstrates a layout using GeometryReader to manage the view's size.

import SwiftUI
struct LayoutView: View {
  var body: some View {
    GeometryReader { proxy in
      HStack {
        Text("Hello, World!") // First text element
          .background(Color.red) // Background color for the first text

        Text("Hello, World!") // Second text element
          .padding() // Padding around the second text
          .background(Color.red) // Background color for the second text
      }
      .frame(width: proxy.size.width * 0.8) // Set the width to 80% of the available width
      .background(Color.gray) // Background color for the HStack
      .padding(
        .leading, (proxy.size.width - proxy.size.width * 0.8) / 2) // Center the HStack horizontally
    }
    .background(Color.yellow) // Background color for the entire view
  }
}

// Preview for LayoutView
struct LayoutView_Previews: PreviewProvider {
  static var previews: some View {
    LayoutView()
      .previewLayout(.fixed(width: 500, height: 300)) // Fixed size for the preview
  }
}
