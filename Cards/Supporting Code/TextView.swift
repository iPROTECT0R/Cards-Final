// TextView

// Created by Raymond Shelton on 9/22/24.

// This view allows users to select a font and color for text display.

import SwiftUI
struct TextView: View {
    @Binding var font: String // Binding for the selected font
    @Binding var color: Color // Binding for the selected color

    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    fonts // Display font selection
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100) // Fixed height for font selection
            }
            HStack {
                colors // Display color selection
            }
        }
        .frame(maxWidth: .infinity)
        .padding([.top, .bottom])
        .background(Color.primary) // Background color for the TextView
    }

    // Displays the available fonts in a horizontal scrollable view
    var fonts: some View {
        ForEach(0..<AppFonts.fonts.count, id: \.self) { index in
            ZStack {
                Circle()
                    .foregroundColor(.primary)
                    .colorInvert() // Invert color for better visibility
                Text("Aa")
                    .font(.custom(AppFonts.fonts[index], size: 20)) // Custom font display
                    .fontWeight(.heavy)
                    .foregroundColor(.primary) // Font color
            }
            .frame(
                width: AppFonts.fonts[index] == font ? 50 : 40,
                height: AppFonts.fonts[index] == font ? 50 : 40) // Size change for selected font
            .onTapGesture {
                withAnimation {
                    font = AppFonts.fonts[index] // Update the selected font with animation
                }
            }
        }
    }

    // Displays color options for selection
    var colors: some View {
        ForEach(1..<8) { index in
            let currentColor = Color("appColor\(index)")
            ZStack {
                Circle()
                    .stroke(Color.white, lineWidth: 1.0) // White border for circles
                    .overlay(
                        Circle()
                            .foregroundColor(color == currentColor ? currentColor : .white)) // Highlight selected color
                    .frame(
                        width: 44,
                        height: 44)
                Circle()
                    .stroke(lineWidth: color == currentColor ? 0 : 1) // Border visibility
                    .overlay(
                        Circle()
                            .foregroundColor(currentColor)) // Display the current color
                    .frame(
                        width: color == currentColor ? 50 : 40,
                        height: color == currentColor ? 50 : 40) // Size change for selected color
            }
            .onTapGesture {
                withAnimation {
                    color = Color("appColor\(index)") // Update selected color with animation
                }
            }
        }
    }
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TextView(
            font: .constant("San Fransisco"), // Default font for preview
            color: .constant(Color("appColor2"))) // Default color for preview
    }
}
