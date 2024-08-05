//
//  ImageCacheManager.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 05/08/2024.
//

import SwiftUI

final class ImageCacheManager {
    static let shared = ImageCacheManager()

    private init() {}

    private var cache = NSCache<NSURL, CacheItem>()

    class CacheItem {
        let image: UIImage
        let expiryDate: Date
        init(image: UIImage, expiryDate: Date) {
            self.image = image
            self.expiryDate = expiryDate
        }
    }

    func image(for url: URL) -> Image? {
        guard let cacheItem = cache.object(forKey: url as NSURL) else {
            return nil
        }

        if cacheItem.expiryDate > Date() {
            return Image(uiImage: cacheItem.image)
        } else {
            cache.removeObject(forKey: url as NSURL)
            return nil
        }
    }

    func storeImage(_ image: UIImage, for url: URL) {
        let expiryDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let cacheItem = CacheItem(image: image, expiryDate: expiryDate)
        cache.setObject(cacheItem, forKey: url as NSURL)
    }
}
