// ResizableView

// Created by Raymond Shelton on 9/22/24.

// This view modifier allows for resizing, rotating, and dragging of a view. It updates the transform properties (position, size, and rotation) based on user gestures.

import SwiftUI

struct ResizableView: ViewModifier {
  @Binding var transform: Transform // Binding to the Transform data structure for position, size, and rotation
  @State private var previousOffset: CGSize = .zero // Track previous offset for dragging
  @State private var previousRotation: Angle = .zero // Track previous rotation for rotation gesture
  @State private var scale: CGFloat = 1.0 // Track current scale during magnification

  let viewScale: CGFloat // Scale factor for the view

  // Drag gesture for moving the view
  var dragGesture: some Gesture {
    DragGesture()
      .onChanged { value in
        // Update the offset based on drag translation
        transform.offset = value.translation / viewScale + previousOffset
      }
      .onEnded { _ in
        // Save the offset when dragging ends
        previousOffset = transform.offset
      }
  }

  // Rotation gesture for rotating the view
  var rotationGesture: some Gesture {
    RotationGesture()
      .onChanged { rotation in
        // Update the rotation based on gesture
        transform.rotation += rotation - previousRotation
        previousRotation = rotation
      }
      .onEnded { _ in
        // Reset the previous rotation after gesture ends
        previousRotation = .zero
      }
  }

  // Scale gesture for resizing the view
  var scaleGesture: some Gesture {
    MagnificationGesture()
      .onChanged { scale in
        // Track the scale during the gesture
        self.scale = scale
      }
      .onEnded { scale in
        // Update the size based on final scale
        transform.size.width *= scale
        transform.size.height *= scale
        self.scale = 1.0 // Reset the scale
      }
  }

  func body(content: Content) -> some View {
    // Apply transformations to the content view
    content
      .frame(
        width: transform.size.width * viewScale, // Set width based on transform and view scale
        height: transform.size.height * viewScale) // Set height based on transform and view scale
      .rotationEffect(transform.rotation) // Apply rotation
      .scaleEffect(scale) // Apply scaling
      .offset(transform.offset * viewScale) // Apply offset
      .gesture(dragGesture) // Add drag gesture
      .gesture(SimultaneousGesture(rotationGesture, scaleGesture)) // Allow simultaneous rotation and scaling
      .onAppear {
        // Initialize the previous offset when the view appears
        previousOffset = transform.offset
      }
  }
}

// Preview provider for displaying the ResizableView in the SwiftUI canvas
struct ResizableView_Previews: PreviewProvider {
  struct ResizableViewPreview: View {
    @State var transform = Transform() // Initialize transform for preview

    var body: some View {
      RoundedRectangle(cornerRadius: 30.0) // Preview shape
        .foregroundColor(Color.blue) // Set color for preview
        .resizableView(transform: $transform) // Apply the resizable view modifier
    }
  }

  static var previews: some View {
    ResizableViewPreview() // Show the preview
  }
}

// Extension to add resizable capabilities to any View
extension View {
  func resizableView(
    transform: Binding<Transform>, // Binding to transform
    viewScale: CGFloat = 1.0 // Optional view scale parameter
  ) -> some View {
    modifier(ResizableView(
      transform: transform, // Pass the transform binding
      viewScale: viewScale)) // Pass the view scale
  }
}
