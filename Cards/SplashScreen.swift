// SplashScreen

// Created by Raymond Shelton on 9/22/24.

// This view displays an animated splash screen with cards that reveal letters. Each card animates into position with a staggered effect for a dynamic entrance.

import SwiftUI

private struct SplashAnimation: ViewModifier {
  @State private var animating = true // Track animation state
  let finalYPosition: CGFloat // Final vertical position for the card
  let delay: Double // Delay for the animation
  let animation = Animation.interpolatingSpring(
    mass: 0.2,
    stiffness: 80,
    damping: 5,
    initialVelocity: 0.0 // Customize spring animation properties
  )

  func body(content: Content) -> some View {
    content
      .offset(y: animating ? -700 : finalYPosition) // Move the card off-screen initially
      .rotationEffect(
        animating ? .zero
          : Angle(degrees: Double.random(in: -10...10))) // Add slight rotation for effect
      .animation(animation.delay(delay), value: animating) // Apply animation with delay
      .onAppear {
        animating = false // Start the animation when the view appears
      }
  }
}

struct SplashScreen: View {
  var body: some View {
    ZStack {
      Color("background") // Background color for the splash screen
        .ignoresSafeArea() // Extend background to fill the screen
      // Create cards with letters, each with a unique animation timing
      card(letter: "S", color: "appColor1")
        .splashAnimation(finalYposition: 240, delay: 0)
      card(letter: "D", color: "appColor2")
        .splashAnimation(finalYposition: 120, delay: 0.2)
      card(letter: "R", color: "appColor3")
        .splashAnimation(finalYposition: 0, delay: 0.4)
      card(letter: "A", color: "appColor6")
        .splashAnimation(finalYposition: -120, delay: 0.6)
      card(letter: "C", color: "appColor7")
        .splashAnimation(finalYposition: -240, delay: 0.8)
    }
  }

  // Function to create individual letter cards
  func card(letter: String, color: String) -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 25) // Card background shape
        .shadow(radius: 3) // Add shadow for depth
        .frame(width: 120, height: 160) // Set card dimensions
        .foregroundColor(.white) // Card background color
      Text(letter) // Display the letter
        .fontWeight(.bold) // Make the letter bold
        .scalableText() // Custom modifier for scalable text
        .foregroundColor(Color(color)) // Set text color based on input
        .frame(width: 80) // Frame for the text
    }
  }
}

// Preview provider for displaying the SplashScreen in the SwiftUI canvas
struct SplashScreen_Previews: PreviewProvider {
  static var previews: some View {
    SplashScreen() // Preview the splash screen
  }
}

// Extension to add splash animation to views
private extension View {
  func splashAnimation(
    finalYposition: CGFloat,
    delay: Double
  ) -> some View {
    modifier(SplashAnimation(
      finalYPosition: finalYposition,
      delay: delay)) // Apply the splash animation modifier
  }
}
