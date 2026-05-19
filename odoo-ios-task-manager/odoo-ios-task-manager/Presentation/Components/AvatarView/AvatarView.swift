//
//  AvatarView.swift
//  odoo-ios-task-manager
//
//  Created by Osama Iqbal on 19/05/2026.
//

import SwiftUI
import Combine

// MARK: - Image Cache Manager
class ImageCacheManager: ObservableObject {
    static let shared = ImageCacheManager()
    private var cache: [String: UIImage] = [:]
    
    func getCachedImage(url: String) -> UIImage? {
        return cache[url]
    }
    
    func setCachedImage(url: String, image: UIImage) {
        cache[url] = image
    }
    
}

// MARK: - Cached Async Image
struct CachedAsyncImage: View {
    let url: String
    let contentMode: ContentMode
    let placeholder: AnyView
    
    @StateObject private var cacheManager = ImageCacheManager.shared
    @State private var cachedUIImage: UIImage?
    
    init(url: String, contentMode: ContentMode = .fill, @ViewBuilder placeholder: () -> some View) {
        self.url = url
        self.contentMode = contentMode
        self.placeholder = AnyView(placeholder())
    }
    
    var body: some View {
        Group {
            if let cachedUIImage = cacheManager.getCachedImage(url: url) {
                Image(uiImage: cachedUIImage)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                AsyncImage(url: URL(string: url)) { phase in
                    switch phase {
                    case .empty:
                        placeholder
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: contentMode)
                            .onAppear {
                                // Cache the successful image as UIImage
                                if let uiImage = image.toUIImage() {
                                    cacheManager.setCachedImage(url: url, image: uiImage)
                                }
                            }
                    case .failure:
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
            }
        }
    }
}

// MARK: - Image Extension
extension Image {
    func toUIImage() -> UIImage? {
        let renderer = ImageRenderer(content: self)
        return renderer.uiImage
    }
}

struct AvatarView: View {
    let imageURL: String?
    let staticImage: Image?
    let name: String?
    let size: CGFloat
    let showBorder: Bool
    let borderColor: Color
    let borderWidth: CGFloat
    let showEditButton: Bool
    let onEditTapped: (() -> Void)?
    let onPress: (() -> Void)?
    
    init(
        imageURL: String? = nil,
        staticImage: Image? = nil,
        name: String? = nil,
        size: CGFloat = 40,
        showBorder: Bool = true,
        borderColor: Color = .accentColor,
        borderWidth: CGFloat = 2,
        showEditButton: Bool = false,
        onEditTapped: (() -> Void)? = nil,
        onPress: (() -> Void)? = nil
    ) {
        self.imageURL = imageURL
        self.staticImage = staticImage
        self.name = name
        self.size = size
        self.showBorder = showBorder
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.showEditButton = showEditButton
        self.onEditTapped = onEditTapped
        self.onPress = onPress
    }
    
    var body: some View {
        ZStack {
            if let staticImage = staticImage {
                // Use static image
                staticImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .padding()
            } else if let imageURL = imageURL, !imageURL.isEmpty {
                // Load image from URL with caching
                CachedAsyncImage(url: imageURL) {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(.white)
                }
            } else {
                // Show initials when no image
                initialsView
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(showBorder ? borderColor : Color.clear, lineWidth: borderWidth)
        )
        .overlay(
            // Edit button overlay (shown when enabled)
            Group {
                if showEditButton {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                onEditTapped?()
                            }) {
                                Image(systemName: "camera")
                                    .font(.system(size: max(12, size * 0.1)))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .frame(width: max(24, size * 0.2), height: max(24, size * 0.2))
                                    .background(.blue)
                                    .clipShape(Circle())
                                    .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                            }
                            .offset(x: -size * 0.05, y: -size * 0.05)
                        }
                    }
                }
            },
            alignment: .bottomTrailing
        )
        .onTapGesture {
            onPress?()
        }
    }
    
    private var initialsView: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [.accentColor.opacity(0.8), .accentColor],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Initials text
            if let initials = getInitials() {
                Text(initials)
                    .font(.system(size: size * 0.4, weight: .bold))
                    .foregroundColor(.white)
            } else {
                // Default icon when no name
                Image(systemName: "person.fill")
                    .font(.system(size: size * 0.5))
                    .foregroundColor(.white)
            }
        }
    }
    
    private func getInitials() -> String? {
        guard let name = name, !name.isEmpty else { return nil }
        
        let components = name
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
        
        if components.count >= 2 {
            return String(components[0].prefix(1)) + String(components[1].prefix(1))
        } else if let first = components.first {
            return String(first.prefix(2))
        }
        
        return nil
    }
}

// MARK: - Convenience Variants
extension AvatarView {
    // Small avatar for lists
    static func small(imageURL: String? = nil, staticImage: Image? = nil, name: String? = nil, onPress: (() -> Void)? = nil) -> AvatarView {
        AvatarView(imageURL: imageURL, staticImage: staticImage, name: name, size: 32, borderWidth: 1, onPress: onPress)
    }
    
    // Medium avatar (default)
    static func medium(imageURL: String? = nil, staticImage: Image? = nil, name: String? = nil, onPress: (() -> Void)? = nil) -> AvatarView {
        AvatarView(imageURL: imageURL, staticImage: staticImage, name: name, size: 40, onPress: onPress)
    }
    
    // Large avatar for profiles
    static func large(imageURL: String? = nil, staticImage: Image? = nil, name: String? = nil, onPress: (() -> Void)? = nil) -> AvatarView {
        AvatarView(imageURL: imageURL, staticImage: staticImage, name: name, size: 80, borderWidth: 3, onPress: onPress)
    }
    
    // Extra large for hero sections
    static func extraLarge(imageURL: String? = nil, staticImage: Image? = nil, name: String? = nil, borderWidth: CGFloat = 4.0, onPress: (() -> Void)? = nil) -> AvatarView {
        AvatarView(imageURL: imageURL, staticImage: staticImage, name: name, size: 120, borderWidth: borderWidth, onPress: onPress)
    }
    
    // Static image convenience method
    static func withStaticImage(_ image: Image, name: String? = nil, size: CGFloat = 40, showBorder: Bool = true, onPress: (() -> Void)? = nil) -> AvatarView {
        AvatarView(staticImage: image, name: name, size: size, showBorder: showBorder, onPress: onPress)
    }
}

// MARK: - Preview
struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                // Small avatar with image
                AvatarView.small(
                    imageURL: "https://picsum.photos/seed/avatar1/100/100.jpg",
                    name: "John Doe"
                )
                
                // Medium avatar with static image
                AvatarView.medium(
                    staticImage: Image(systemName: "person.fill"),
                    name: "Jane Smith"
                )
                
                // Large avatar with image
                AvatarView.large(
                    imageURL: "https://picsum.photos/seed/avatar2/200/200.jpg",
                    name: "Robert Johnson"
                )
            }
            
            HStack(spacing: 20) {
                // Extra large with initials
                AvatarView.extraLarge(
                    name: "Alice Williams"
                )
                
                // Custom size with static image
                AvatarView(
                    staticImage: Image(systemName: "star.fill"),
                    name: "Bob Brown",
                    size: 60,
                    showBorder: false,
                    showEditButton: true
                )
            }
            
            // Using the convenience method
            HStack(spacing: 20) {
                AvatarView.withStaticImage(
                    Image(systemName: "heart.fill"),
                    name: "Static Avatar",
                    size: 50
                )
                
                AvatarView.withStaticImage(
                    Image(systemName: "camera.fill"),
                    name: "Camera",
                    size: 50
                )
            }
        }
        .padding()
        .background(Color.black)
        .previewLayout(.sizeThatFits)
    }
}
