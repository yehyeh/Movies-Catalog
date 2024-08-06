//
//  CachedAsyncImage.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 05/08/2024.
//
import SwiftUI

struct CachedAsyncImage<Placeholder: View, Content: View>: View {
    private let url: URL?
    private let content: (Image) -> Content
    private let placeholder: Placeholder
    @State private var image: Image? = nil

    init(url: URL?,
         @ViewBuilder content: @escaping (Image) -> Content,
         @ViewBuilder placeholder: () -> Placeholder) {
        self.url = url
        self.content = content
        self.placeholder = placeholder()
    }

    var body: some View {
        ZStack {
            if let image {
                content(image)
            } else {
                placeholder
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }

    private func loadImage() {
        guard let url = url else {
            return
        }

        if let cachedImage = ImageCacheManager.shared.image(for: url) {
            image = cachedImage
        } else {
            Task {
                if let downloadedImage = await fetchImage(from: url) {
                    ImageCacheManager.shared.storeImage(downloadedImage, for: url)
                    DispatchQueue.main.async {
                        self.image = Image(uiImage: downloadedImage)
                    }
                }
            }
        }
    }

    private func fetchImage(from url: URL) async -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            print("Error fetching image: \(error)")
            return nil
        }
    }
}
