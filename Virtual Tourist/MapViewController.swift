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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(addPin)))
    }
    
    @objc func addPin(sender: UIGestureRecognizer){
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        let anonotation = MKPointAnnotation()
        anonotation.coordinate = coordinate
        mapView.addAnnotation(anonotation)
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.performSegue(withIdentifier: "showImageSelectorViewController", sender: view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showImageSelectorViewController"){
            let destination = segue.destination as! ImageSelectorViewController
            guard let annotationView = sender as? MKAnnotationView else {return}
            destination.annotation = annotationView.annotation
        }
    }
}
