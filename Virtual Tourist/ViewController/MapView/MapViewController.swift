//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by iOS Developer on 22/02/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView:MKMapView!
    var editMode = false
    var pins = [Pin]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(addPin)))
        pins = CoreDataManager.share.fetchPins()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        insertPins()
    }
    
    @objc func addPin(sender: UIGestureRecognizer){
        if sender.state == .began {
            if (editMode){return}
            let point = sender.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            let anonotation = MKPointAnnotation()
            anonotation.coordinate = coordinate
            mapView.addAnnotation(anonotation)
            let tuple = CoreDataManager.share.createPin(Double(coordinate.latitude), Double(coordinate.longitude))
            
            guard let pin = tuple.0 else {return}
            pins.append(pin)
        }
    }
    
    @IBAction func handleEditButton(_ sender: Any) {
        editMode = !editMode
        var yValue: CGFloat = 0
        
        yValue = editMode ? self.mapView.frame.origin.y-60 : self.mapView.frame.origin.y+60
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.mapView.frame.origin.y = yValue
            self.navigationItem.rightBarButtonItem?.title = self.editMode ? "Done": "Edit"
        }, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == Strings.ShowImageSelectorSegue){
            let destination = segue.destination as! ImageSelectorViewController
            guard let annotationView = sender as? MKAnnotationView else {return}
            destination.annotation = annotationView.annotation
        }
    }
}
