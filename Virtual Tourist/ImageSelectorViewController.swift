//
//  ImageSelectorViewController.swift
//  Virtual Tourist
//
//  Created by Luiz Hammerli on 22/02/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit
import MapKit

class ImageSelectorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MKMapViewDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView:MKMapView!
    @IBOutlet weak var updateButton: UIButton!
    var annotation: MKAnnotation?
    
    var photos = [Photo(id: 0, color: UIColor.red), Photo(id: 1, color: UIColor.blue), Photo(id: 2, color: UIColor.green), Photo(id: 3, color: UIColor.purple), Photo(id: 4, color: UIColor.orange)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let annotation = annotation{
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    func setUpViews(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        mapView.isUserInteractionEnabled = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! ImageCollectionViewCell
        cell.backgroundColor = photos[indexPath.item].color
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.view.frame.width-15)/3
        return CGSize(width: size, height: size)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        cell.highlightedView.isHidden = false
        changeButtonLabel()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        cell.highlightedView.isHidden = true
        changeButtonLabel()
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
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }    
    @IBAction func returnToMapViewController(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
