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
            self.isUserInteractionEnabled = false
            guard let url = photo?.url else {return}
            self.showActivityIndicator(true)
            mainImageView.downloadImage(stringURL: url) {
                guard let image = self.mainImageView.image else {return}
                let imageData = UIImageJPEGRepresentation(image, 0.8)
                self.photo?.image = imageData
                self.showActivityIndicator(false)
                self.isUserInteractionEnabled = true
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
}
