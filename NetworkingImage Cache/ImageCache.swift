//
//  ImageCacher.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 08.01.26.
//

import Foundation
import UIKit

final class ImageCache {

    static let shared = ImageCache()
    private init() {}

    private let cache = NSCache<NSString, UIImage>()

    func getImage(for key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    func saveImage(image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
