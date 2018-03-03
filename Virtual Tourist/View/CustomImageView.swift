//
//  CustomImageView.swift
//  Virtual Tourist
//
//  Created by iOS Developer on 28/02/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    
    func downloadImage(stringURL: String,  completionHandler: @escaping() -> Void){
        self.image = nil
        
        guard let url = URL(string: stringURL) else {return}
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {return}
            DispatchQueue.main.async {
                self.image = UIImage(data: imageData)                
                completionHandler()
            }
        }        
    }
}
