//
//  Extension+UIImageView.swift
//  KDogsApp
//
//  Created by Pablo Ramirez on 18/06/25.
//

import UIKit

fileprivate let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        image = nil
        
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            image = cachedImage
            
            return
        }

        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in

                if error != nil {
                    DispatchQueue.main.async { [weak self] in
                        self?.image = placeHolder
                    }
                    
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self?.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}
