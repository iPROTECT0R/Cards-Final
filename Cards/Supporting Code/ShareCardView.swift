// ShareCardView

// Created by Raymond Shelton on 9/22/24.

// This view displays a card with its elements, using a geometry reader to adapt its size.

import SwiftUI
struct ShareCardView: View {
    let card: Card

    var body: some View {
        GeometryReader { proxy in
            content(size: proxy.size) // Render content based on the available size
        }
    }

    // Main content of the card view
    func content(size: CGSize) -> some View {
        ZStack {
            card.backgroundColor // Background color of the card
            elements(size: size)  // Render the card's elements
        }
        .frame(
            width: Settings.calculateSize(size).width,
            height: Settings.calculateSize(size).height)
        .clipped() // Prevent content overflow
    }

    // Renders the elements of the card
    func elements(size: CGSize) -> some View {
        let viewScale = Settings.calculateScale(size) // Calculate the scaling factor
        return ForEach(card.elements, id: \.id) { element in
            CardElementView(element: element) // View for individual card element
                .frame(
                    width: element.transform.size.width,
                    height: element.transform.size.height)
                .rotationEffect(element.transform.rotation) // Apply rotation
                .scaleEffect(viewScale) // Apply scaling
                .offset(element.transform.offset * viewScale) // Position the element
        }
    }
}

struct ShareCardView_Previews: PreviewProvider {
    static var previews: some View {
        ShareCardView(card: initialCards[0]) // Preview with the first initial card
    }
}
