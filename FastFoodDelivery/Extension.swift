//
//  Extension.swift
//  FastFoodDelivery
//
//  Created by Richard Rusli on 4/06/2017.
//  Copyright © 2017 Richard. All rights reserved.
//

import UIKit
let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView{
    
    func loadImageUsingCacheWithUrlString(urlString: String){
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as?
            UIImage{
                self.image = cachedImage
            return
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil{
                print(error)
                return
            }
            
            //doing a task which is putting the self image with downloaded image from firebase
            DispatchQueue.main.async(execute: {
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                    print(downloadedImage)
                }
            })
        }).resume()
    }
    
}
