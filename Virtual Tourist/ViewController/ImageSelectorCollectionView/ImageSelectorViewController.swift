//
//  ImageSelectorViewController.swift
//  Virtual Tourist
//
//  Created by Luiz Hammerli on 22/02/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit
import MapKit

class ImageSelectorViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView:MKMapView!
    @IBOutlet weak var updateButton: UIButton!
    var annotation: MKAnnotation?
    
    var totalPages = 0
    var photos = [[String:Any]]()
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setUpViews()
        loadImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let annotation = annotation{
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    func loadImage(page: String? = nil){
        if let annotation = annotation{
            updateButton.isEnabled = false
            let bbox =  "\(annotation.coordinate.longitude), \(annotation.coordinate.latitude), \(annotation.coordinate.longitude+1), \(annotation.coordinate.latitude+1)"
            
            FlickrClient.shared.getFlickrImages(bbox, page, completionHandler: { (total, photos, error) in
                if let _ = error{
                    print("error")
                    return
                }
                
                guard let total = total, let photos = photos else {return}
                self.totalPages = total
                self.photos = photos
                DispatchQueue.main.async {
                    photos.count > 0 ? self.collectionView.reloadData(): self.showEmptyLabel()
                    self.updateButton.isEnabled = true
                }                
            })
        }
    }
    
    func showEmptyLabel(){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        self.view.addSubview(label)
        label.text = "This pin has no image"
        self.label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.label.heightAnchor.constraint(equalToConstant: 200).isActive = true
        self.label.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func setUpViews(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        mapView.isUserInteractionEnabled = false
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView.reloadData()
    }
    
    func changeButtonLabel(){
        guard let count = collectionView.indexPathsForSelectedItems?.count else {return}
        if(count > 0){
            updateButton.setTitle("Remove Selected Pictures", for: .normal)
            return
        }
        
        updateButton.setTitle("New Collection", for: .normal)
    }

    @IBAction func updateCollectionView(_ sender: Any) {
        updateButton.titleLabel?.text == Strings.NewCollectionButtonLabel ? loadNewImages() : removeImage()
    }
    
    func loadNewImages(){
        self.photos.removeAll()
        self.collectionView.reloadData()
        let randomPage = Int(arc4random_uniform(UInt32(20)))
        loadImage(page: "\(randomPage)")
    }
    
    func removeImage(){

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.pinTintColor = .red
        }else{
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    @IBAction func returnToMapViewController(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
