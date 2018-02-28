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
    
    var imageUrl: String?{
        didSet{
            self.isUserInteractionEnabled = false
            guard let url = imageUrl else {return}
            self.showActivityIndicator(true)
            mainImageView.downloadImage(stringURL: url) {
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
