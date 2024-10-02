// Transform

// Created by Raymond Shelton on 9/22/24.

// This struct represents the transformation properties for a card element, including its size, rotation, and position offset.

import SwiftUI
struct Transform {
  var size = CGSize(
    width: Settings.defaultElementSize.width,
    height: Settings.defaultElementSize.height) // Default size based on app settings
  var rotation: Angle = .zero // Initial rotation angle
  var offset: CGSize = .zero // Offset from the original position
}

// Conformance to Codable for easy saving/loading
extension Transform: Codable {}
