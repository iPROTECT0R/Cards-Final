// Operators

// Created by Raymond Shelton on 9/22/24.

// Extension to perform arithmetic operations on CGSize. This allows CGSize to be manipulated like numbers, making layout calculations easier.

import SwiftUI


func + (left: CGSize, right: CGSize) -> CGSize {
  CGSize(
    width: left.width + right.width, // Combine widths
    height: left.height + right.height // Combine heights
  )
}

func * (left: CGSize, right: CGFloat) -> CGSize {
  CGSize(
    width: left.width * right, // Scale the width
    height: left.height * right // Scale the height
  )
}


func *= (left: inout CGSize, right: Double) {
  left = CGSize(
    width: left.width * right, // Update the width
    height: left.height * right // Update the height
  )
}


func / (left: CGSize, right: CGFloat) -> CGSize {
  CGSize(
    width: left.width / right, // Divide the width
    height: left.height / right // Divide the height
  )
}
