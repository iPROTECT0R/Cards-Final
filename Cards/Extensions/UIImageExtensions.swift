// UIImageExtensions

// Created by Raymond Shelton on 9/22/24.

// This file extends UIImage for handling image transfer, resizing, and file operations.

import SwiftUI

// Conform UIImage to the Transferable protocol for drag-and-drop functionality
extension UIImage: Transferable {
    // Define how UIImage can be transferred between apps
    public static var transferRepresentation: some TransferRepresentation {
        // Handle importing image data and return a UIImage
        DataRepresentation(importedContentType: .image) { image in
            UIImage(data: image) ?? errorImage // Use a placeholder if loading fails
        }
    }

    // Placeholder image in case of errors
    public static var errorImage: UIImage {
        UIImage(named: "error-image") ?? UIImage() // Return a default image if none is found
    }
}

// MARK: - SAVE, LOAD AND DELETE IMAGE FILE
extension UIImage {
    // Define minimum and maximum sizes for images
    static var minsize = CGSize(width: 300, height: 200)
    static var maxSize = CGSize(width: 1000, height: 1500)

    // Save the image to disk, optionally using a specified filename
    func save(to filename: String? = nil) -> String {
        // Resize the image if it exceeds maximum size before saving
        let image = resizeLargeImage()
        let path: String
        // Use provided filename or generate a unique one
        if let filename = filename {
            path = filename
        } else {
            path = UUID().uuidString
        }
        let url = URL.documentsDirectory.appendingPathComponent(path)
        do {
            // Write the image data to the specified URL
            try image.pngData()?.write(to: url)
        } catch {
            // Log any errors that occur during saving
            print(error.localizedDescription)
        }
        return path // Return the path used for saving
    }

    // Load an image from disk using its UUID string
    static func load(uuidString: String) -> UIImage? {
        // Return nil if the UUID is "none"
        guard uuidString != "none" else { return nil }
        let url = URL.documentsDirectory.appendingPathComponent(uuidString)
        // Attempt to load image data from the specified URL
        if let imageData = try? Data(contentsOf: url) {
            return UIImage(data: imageData) // Return the loaded UIImage
        } else {
            return nil // Return nil if loading fails
        }
    }

    // Remove an image from disk using its filename
    static func remove(name: String?) {
        if let name {
            let url = URL.documentsDirectory.appendingPathComponent(name)
            try? FileManager.default.removeItem(at: url) // Attempt to delete the file
        }
    }
}

// MARK: - GET IMAGE SIZE
extension UIImage {
    // Calculate the initial size of the image for display
    func initialSize() -> CGSize {
        var width = Settings.defaultElementSize.width
        var height = Settings.defaultElementSize.height

        // Adjust dimensions based on the image's aspect ratio
        if self.size.width >= self.size.height {
            width = max(Self.minsize.width, width) // Ensure minimum width
            width = min(Self.maxSize.width, width) // Ensure maximum width
            height = self.size.height * (width / self.size.width) // Calculate height based on aspect ratio
        } else {
            height = max(Self.minsize.height, height) // Ensure minimum height
            height = min(Self.maxSize.height, height) // Ensure maximum height
            width = self.size.width * (height / self.size.height) // Calculate width based on aspect ratio
        }
        return CGSize(width: width, height: height) // Return the calculated size
    }

    // Get the initial size of a named image
    static func imageSize(named imageName: String) -> CGSize {
        if let image = UIImage(named: imageName) {
            return image.initialSize() // Return the initial size of the loaded image
        }
        return .zero // Return zero size if image not found
    }
}

// MARK: - RESIZE IMAGE
extension UIImage {
    // Resize the image if it exceeds the default size
    func resizeLargeImage() -> UIImage {
        let defaultSize: CGFloat = 1000 // Define a default size threshold
        // Return the original image if it's within size limits
        if size.width <= defaultSize || size.height <= defaultSize { return self }

        let scale: CGFloat
        // Determine the scaling factor based on the larger dimension
        if size.width >= size.height {
            scale = defaultSize / size.width
        } else {
            scale = defaultSize / size.height
        }
        let newSize = CGSize(
            width: size.width * scale,
            height: size.height * scale) // Calculate the new size
        return resize(to: newSize) // Resize the image to the new dimensions
    }

    // Resize the image to the specified dimensions
    func resize(to size: CGSize) -> UIImage {
        // Set up an image renderer to create the resized image
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1 // Use a scale of 1 for the actual image size
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            draw(in: CGRect(origin: .zero, size: size)) // Draw the image in the new size
        }
    }
}

// MARK: - SCREENSHOT FUNCTIONALITY
extension UIImage {
    // Capture a screenshot of a card view
    @MainActor static func screenshot(
        card: Card,
        size: CGSize
    ) -> UIImage {
        let cardView = ShareCardView(card: card) // Create a view for the card
        let content = cardView.content(size: size) // Render the card's content
        let renderer = ImageRenderer(content: content) // Create an image renderer
        let uiImage = renderer.uiImage ?? UIImage.errorImage // Get the rendered image or use an error placeholder
        return uiImage // Return the captured image
    }
}
