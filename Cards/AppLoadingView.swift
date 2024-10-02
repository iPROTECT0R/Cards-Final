// AppLoadingView

// Created by Raymond Shelton on 9/22/24.

// This view manages the loading screen for the app. It initially shows a splash screen and then transitions to the main content view.

import SwiftUI

struct AppLoadingView: View {
  // State variable to control the visibility of the splash screen
  @State private var showSplash = true

  var body: some View {
    // Check if the splash screen should be displayed
    if showSplash {
      SplashScreen() // Display the splash screen
        .ignoresSafeArea() // Make the splash screen fill the entire screen
        .onAppear {
          // Delay the transition to the main view
          DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
              showSplash = false // Hide the splash screen after the delay
            }
          }
        }
    } else {
      CardsListView() // Show the main cards list view after the splash
        .transition(.scale(scale: 0, anchor: .top)) // Animate the transition
    }
  }
}

// Preview provider for displaying the AppLoadingView in the SwiftUI canvas
struct AppLoadingView_Previews: PreviewProvider {
  static var previews: some View {
    AppLoadingView()
      .environmentObject(CardStore(defaultData: true)) // Provide a mock CardStore for previews
  }
}
