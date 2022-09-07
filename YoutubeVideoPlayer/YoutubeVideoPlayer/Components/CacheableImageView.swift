//
//  CacheableImageView.swift
//  YoutubeVideoPlayer
//
//  Created by Osaretin Uyigue on 9/6/22.
//

import UIKit

/// A UIImageView that caches image downloads from remoteURLs using NSCache
class CacheableImageView: UIImageView {
    
    //MARK: - Properties
    let imageCache = NSCache<NSString, AnyObject>()
    
    
    //MARK: - Methods
    func getImage(for urlString: String) {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
        } else {
            guard let remoteUrl = URL(string: urlString) else {return}
            downloadImage(from: remoteUrl)
        }
    }
    
    
    
   fileprivate func downloadImage(from remoteUrl: URL) {
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: remoteUrl) { data, response, error in
                guard error == nil, let data = data else {return}
                
                DispatchQueue.main.async {
                    guard let imageToCache = UIImage(data: data) else {return}
                    self.imageCache.setObject(imageToCache, forKey: remoteUrl.absoluteString as NSString)
                    self.image = imageToCache
                }
            }.resume()
        }
    }
    
}


