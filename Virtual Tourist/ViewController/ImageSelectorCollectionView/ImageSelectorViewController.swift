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
    
    var photos = [Photo(id: 0, color: UIColor.red), Photo(id: 1, color: UIColor.blue), Photo(id: 2, color: UIColor.green), Photo(id: 3, color: UIColor.purple), Photo(id: 4, color: UIColor.orange)]
    
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
    
    func loadImage(){
        if let annotation = annotation{
            FlickrClient.shared.getFlickrImages(bbox: "\(annotation.coordinate.longitude), \(annotation.coordinate.latitude), \(annotation.coordinate.longitude+1), \(annotation.coordinate.latitude+1)")
        }
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
        guard let selectedCells = collectionView.indexPathsForSelectedItems else {return}
        for indexPath in selectedCells{
            for index in 0...photos.count-1{
                if(photos[index].id == photos[indexPath.item].id){
                    let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
                    cell.highlightedView.isHidden = true
                    photos.remove(at: index)
                    break
                }
            }
        }
        self.collectionView.reloadData()
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
