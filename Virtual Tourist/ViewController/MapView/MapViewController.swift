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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(addPin)))
    }
    
    @objc func addPin(sender: UIGestureRecognizer){
        if sender.state == .began {
            if (editMode){return}
            let point = sender.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            let anonotation = MKPointAnnotation()
            anonotation.coordinate = coordinate
            mapView.addAnnotation(anonotation)
        }
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
        guard let annotation = view.annotation else {return}
        mapView.deselectAnnotation(annotation, animated: true)
        if (!editMode){
            self.performSegue(withIdentifier: Strings.ShowImageSelectorSegue, sender: view)
        }else{
            mapView.removeAnnotation(annotation)
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
