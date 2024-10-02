// Shapes

// Created by Raymond Shelton on 9/22/24.

// This file defines various shapes and provides an enumeration to access them.

import SwiftUI

enum Shapes {
    // An array of different shapes wrapped in AnyShape for easy access.
    static let shapes: [AnyShape] = [
        AnyShape(Circle()), // A classic circle.
        AnyShape(Rectangle()), // A standard rectangle.
        AnyShape(RoundedRectangle(cornerRadius: 25.0)), // A rectangle with rounded corners.
        AnyShape(Heart()), // A heart shape, perfect for romantic themes.
        AnyShape(Lens()), // A lens shape, ideal for a photography vibe.
        AnyShape(Chevron()), // A chevron shape, great for navigation.
        AnyShape(Cone()), // A cone shape, reminiscent of ice cream cones!
        AnyShape(Cloud()), // A fluffy cloud shape for a dreamy effect.
        AnyShape(Diamond()), // A shiny diamond shape.
        AnyShape(Polygon(sides: 6)), // A hexagon shape, perfect for honeycombs.
        AnyShape(Polygon(sides: 8)) // An octagon shape, like a stop sign.
    ]
}

// Preview provider for displaying shapes in Xcode previews.
struct Shapes_Previews: PreviewProvider {
    static let currentShape = Lens() // Choose a shape to preview.

    static var previews: some View {
        currentShape
            .stroke(
                Color.primary, // Use the primary color for the stroke.
                style: StrokeStyle(lineWidth: 10, lineJoin: .round) // Stroke style with rounded edges.
            )
            .padding() // Add some padding around the shape.
            .aspectRatio(1, contentMode: .fit) // Keep the shape square in the preview.
            .background(Color.yellow) // A bright yellow background.
            .previewLayout(.sizeThatFits) // Layout that adjusts to the shape's size.
    }
}

// Triangle shape definition.
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        var path = Path()
        // Define the points that make up the triangle.
        path.addLines([
            CGPoint(x: width * 0.13, y: height * 0.2), // Top left point.
            CGPoint(x: width * 0.87, y: height * 0.47), // Bottom right point.
            CGPoint(x: width * 0.4, y: height * 0.93) // Bottom left point.
        ])
        path.closeSubpath() // Close the triangle shape.
        return path
    }
}

// Cone shape definition.
struct Cone: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = min(rect.midX, rect.midY) // Use the smaller dimension for radius.
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY), // Center of the cone.
            radius: radius,
            startAngle: Angle(degrees: 0), // Start from the top.
            endAngle: Angle(degrees: 180), // Draw to the bottom.
            clockwise: true) // Draw clockwise.
        path.addLine(to: CGPoint(x: rect.midX, y: rect.height)) // Draw line down to the bottom.
        path.addLine(to: CGPoint(x: rect.midX + radius, y: rect.midY)) // Complete the cone shape.
        path.closeSubpath() // Close the path.
        return path
    }
}

// Lens shape definition.
struct Lens: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.midY)) // Start at the middle of the left edge.
        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: rect.midY), // Draw to the middle of the right edge.
            control: CGPoint(x: rect.midX, y: 0)) // Control point at the top.
        path.addQuadCurve(
            to: CGPoint(x: 0, y: rect.midY), // Draw back to the start.
            control: CGPoint(x: rect.midX, y: rect.height)) // Control point at the bottom.
        path.closeSubpath() // Close the lens shape.
        return path
    }
}

// Heart shape definition.
struct Heart: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY)) // Start at the bottom tip.
        path.addCurve(
            to: CGPoint(x: rect.minX, y: rect.height * 0.25), // Left curve.
            control1: CGPoint(x: rect.midX * 0.7, y: rect.height * 0.9), // Control point.
            control2: CGPoint(x: rect.minX, y: rect.midY)) // Another control point.
        path.addArc(
            center: CGPoint(
                x: rect.width * 0.25,
                y: rect.height * 0.25), // Left arc center.
            radius: (rect.width * 0.25), // Arc radius.
            startAngle: Angle(radians: .pi), // Start from left.
            endAngle: Angle(radians: 0), // End to right.
            clockwise: false) // Draw counter-clockwise.
        path.addArc(
            center: CGPoint(
                x: rect.width * 0.75,
                y: rect.height * 0.25), // Right arc center.
            radius: (rect.width * 0.25), // Arc radius.
            startAngle: Angle(radians: .pi), // Start from left.
            endAngle: Angle(radians: 0), // End to right.
            clockwise: false) // Draw counter-clockwise.
        path.addCurve(
            to: CGPoint(x: rect.midX, y: rect.height), // Draw back to the bottom point.
            control1: CGPoint(x: rect.width, y: rect.midY), // Control point on the right.
            control2: CGPoint(x: rect.midX * 1.3, y: rect.height * 0.9)) // Control point below.
        path.closeSubpath() // Close the heart shape.
        return path
    }
}

// Diamond shape definition.
struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height
            // Define the four points that create the diamond shape.
            path.addLines([
                CGPoint(x: width / 2, y: 0), // Top point.
                CGPoint(x: width, y: height / 2), // Right point.
                CGPoint(x: width / 2, y: height), // Bottom point.
                CGPoint(x: 0, y: height / 2) // Left point.
            ])
            path.closeSubpath() // Close the diamond shape.
        }
    }
}

// Cloud shape definition.
struct Cloud: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        path.move(to: CGPoint(x: width * 0.2, y: height * 0.2)) // Starting point for the cloud.
        path.addQuadCurve(
            to: CGPoint(x: width * 0.6, y: height * 0.1), // Upper left curve.
            control: CGPoint(x: width * 0.32, y: height * -0.12)) // Control point.
        path.addQuadCurve(
            to: CGPoint(x: width * 0.85, y: height * 0.2), // Upper right curve.
            control: CGPoint(x: width * 0.8, y: height * 0.05)) // Control point.
        path.addQuadCurve(
            to: CGPoint(x: width * 0.9, y: height * 0.6), // Lower right curve.
            control: CGPoint(x: width * 1.1, y: height * 0.35)) // Control point.
        path.addQuadCurve(
            to: CGPoint(x: width * 0.65, y: height * 0.9), // Lower middle curve.
            control: CGPoint(x: width * 1, y: height * 0.95)) // Control point.
        path.addQuadCurve(
            to: CGPoint(x: width * 0.15, y: height * 0.7), // Lower left curve.
            control: CGPoint(x: width * 0.2, y: height * 1.1)) // Control point.
        path.addQuadCurve(
            to: CGPoint(x: width * 0.2, y: height * 0.2), // Closing curve.
            control: CGPoint(x: width * -0.15, y: height * 0.45)) // Control point for closing.
        path.closeSubpath() // Close the cloud shape.
        return path
    }
}

// Chevron shape definition.
struct Chevron: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            // Define the points that make up the chevron.
            path.addLines([
                .zero, // Start at the top-left corner.
                CGPoint(x: rect.width * 0.75, y: 0), // Top edge of the chevron.
                CGPoint(x: rect.width, y: rect.height * 0.5), // Pointing to the center.
                CGPoint(x: rect.width * 0.75, y: rect.height), // Bottom edge of the chevron.
                CGPoint(x: 0, y: rect.height), // Bottom-left corner.
                CGPoint(x: rect.width * 0.25, y: rect.height * 0.5) // Return to the center.
            ])
            path.closeSubpath() // Close the chevron shape.
        }
    }
}

// Polygon shape definition with a variable number of sides.
struct Polygon: Shape {
    let sides: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = min(rect.midX, rect.midY) // Use the smaller dimension for radius.
        let angle = CGFloat.pi * 2 / CGFloat(sides) // Calculate the angle between points.
        // Calculate the points of the polygon.
        let points: [CGPoint] = (0..<sides).map { index in
            let currentAngle = angle * CGFloat(index) // Current angle for the vertex.
            let pointX = radius * cos(currentAngle) + radius // X-coordinate.
            let pointY = radius * sin(currentAngle) + radius // Y-coordinate.
            return CGPoint(x: pointX, y: pointY) // Create the point.
        }
        path.move(to: points[0]) // Move to the first point.
        for i in 1..<points.count {
            path.addLine(to: points[i]) // Draw lines to each subsequent point.
        }
        path.closeSubpath() // Close the polygon shape.
        return path
    }
}
