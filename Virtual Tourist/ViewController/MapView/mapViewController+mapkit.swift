//
//  mapViewController+mapkit.swift
//  Virtual Tourist
//
//  Created by iOS Developer on 01/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController{
    
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
        guard let annotation = view.annotation else {return}
        mapView.deselectAnnotation(annotation, animated: true)
        if (!editMode){
            self.performSegue(withIdentifier: Strings.ShowImageSelectorSegue, sender: view)
        }else{                        
            removePin(annotation)
        }
    }
    
    func insertPins(){
        for pin in pins{
            let latitude = CLLocationDegrees(pin.latitude)
            let longitude = CLLocationDegrees(pin.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }
    }
    
    func removePin(_ annotation: MKAnnotation){
        for pin in pins {
            if pin.latitude == Double(annotation.coordinate.latitude) && pin.longitude == Double(annotation.coordinate.longitude){
                if(CoreDataManager.share.removePin(pin)){
                    mapView.removeAnnotation(annotation)
                    mapView.showAnnotations(mapView.annotations, animated: true)
                }
            }
        }
    }
}
