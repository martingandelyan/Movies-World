//
//  UIImageView+Cache.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 08.01.26.
//

import UIKit

extension UIImageView {

    func setImage(from urlString: String) {
        if let cachedImage = ImageCache.shared.getImage(for: urlString) {
            self.image = cachedImage
            return
        }

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard
                let data,
                let image = UIImage(data: data),
                error == nil
            else { return }

            ImageCache.shared.saveImage(image: image, for: urlString)

            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
