//
//  CustomImageView.swift
//  Virtual Tourist
//
//  Created by iOS Developer on 28/02/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    
    static var cachedImages = [[String: UIImage]]()
    
    func downloadImage(stringURL: String,  completionHandler: @escaping() -> Void){
        self.image = nil
        
        for cachedImage in CustomImageView.cachedImages{
            if let image = cachedImage[stringURL]{
                self.image = image
                completionHandler()
                return
            }
        }
        
        guard let url = URL(string: stringURL) else {return}
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {return}
            DispatchQueue.main.async {
                self.image = UIImage(data: imageData)
                CustomImageView.cachedImages.append([stringURL: self.image!])
                completionHandler()
            }
        }        
    }
}
