//
//  MapViewController.swift
//  Virtual Tourist
//
//  Created by iOS Developer on 22/02/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView:MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(addPin)))
    }
    
    @objc func addPin(sender: UIGestureRecognizer){
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        let anonotation = MKPointAnnotation()
        anonotation.coordinate = coordinate
        mapView.addAnnotation(anonotation)
    }
}

