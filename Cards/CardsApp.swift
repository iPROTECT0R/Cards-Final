// CardsApp

// Created by Raymond Shelton on 9/22/24.

// This is the main entry point for the Cards application. It sets up the app's environment and initializes the data store.

import SwiftUI

@main
struct CardsApp: App {
  // Initialize the CardStore with default data
  @StateObject var store = CardStore(defaultData: true)

  var body: some Scene {
    WindowGroup {
      // Display the loading view for the app
      AppLoadingView()
        .environmentObject(store) // Provide the CardStore to the environment
        .onAppear {
          // Log the documents directory URL for debugging
          print(URL.documentsDirectory)
        }
    }
  }
}
