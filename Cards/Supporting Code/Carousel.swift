// Carousel

// Created by Raymond Shelton on 9/22/24.

// This view displays a carousel of cards, allowing users to swipe through them and select a card.

import SwiftUI
struct Carousel: View {
    @EnvironmentObject var store: CardStore
    @Binding var selectedCard: Card?

    let thumbnailScale: CGFloat = 0.7

    // Calculates the size of the card based on the available proxy size
    func cardSize(from proxySize: CGSize) -> CGSize {
        let cardSize = Settings.calculateSize(proxySize)
        return cardSize * thumbnailScale
    }

    var body: some View {
        GeometryReader { proxy in
            TabView {
                ForEach((0..<store.cards.count), id: \.self) { index in
                    cardView(store.cards[index])
                        .frame(
                            width: cardSize(from: proxy.size).width,
                            height: cardSize(from: proxy.size).height)
                        .cornerRadius(15)
                        .shadow(
                            color: Color(white: 0.5, opacity: 0.7),
                            radius: 5)
                        .onTapGesture {
                            selectedCard = store.cards[index]
                        }
                        .offset(y: -proxy.size.height * 0.05)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .tabViewStyle(PageTabViewStyle())
        }
    }

    // View for displaying a single card
    func cardView(_ card: Card) -> some View {
        Group {
            if let image = loadCardImage(card) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                card.backgroundColor
            }
        }
    }

    // Loads the image associated with a card
    func loadCardImage(_ card: Card) -> Image? {
        if let uiImage = UIImage.load(uuidString: card.id.uuidString) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
}

struct Carousel_Previews: PreviewProvider {
    static var previews: some View {
        Carousel(selectedCard: .constant(Card()))
            .environmentObject(CardStore(defaultData: true))
    }
}
