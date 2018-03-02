//
//  ImageCollectionViewCell.swift
//  Virtual Tourist
//
//  Created by Luiz Hammerli on 22/02/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {    
    @IBOutlet weak var mainImageView: CustomImageView!
    @IBOutlet weak var highlightedView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var photo: Photo?{
        didSet{
            guard let url = photo?.url else {return}
            self.showActivityIndicator(true)            
            if let imageData = photo?.image{
                self.showActivityIndicator(false)
                let image = UIImage(data: imageData)
                mainImageView.image = image
            }else{
                downloadImage(url)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainImageView.layer.cornerRadius = 2
        showActivityIndicator(false)
    }
    
    func showActivityIndicator(_ show: Bool){
        self.activityIndicator.isHidden = !show
        show ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    func downloadImage(_ stringURL: String){
        self.isUserInteractionEnabled = false
        mainImageView.downloadImage(stringURL: stringURL) {
            guard let image = self.mainImageView.image else {return}
            let imageData = UIImageJPEGRepresentation(image, 0.8)
            self.photo?.image = imageData
            if CoreDataManager.share.saveContext(){
                self.showActivityIndicator(false)
                self.isUserInteractionEnabled = true
            }
        }
    }
}
