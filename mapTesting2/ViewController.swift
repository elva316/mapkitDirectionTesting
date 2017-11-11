//
//  ViewController.swift
//  mapTesting2
//
//  Created by elva wang on 11/9/17.
//  Copyright © 2017 elva wang. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapKitView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapKitView.delegate = self
        mapKitView.showsScale = true
        mapKitView.showsPointsOfInterest = true   //  grab a building/location
        mapKitView.showsUserLocation = true
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        // geting directions
        let sourceCoordinates = locationManager.location?.coordinate     // direction coordinate
        let destCoordinates = CLLocationCoordinate2DMake(37.3352, -121.8811)    //   getting destination coordinate
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinates!)
        let destPlacemark = MKPlacemark(coordinate: destCoordinates)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {
            response, error in
            
            guard let response = response else {        //  make the app realizable
                if let error = error {
                    print("Something  Went Wrong", error)
                }
                return
            }
            let route = response.routes[0]
            self.mapKitView.add(route.polyline, level: .aboveRoads)
            
            let rekt =  route.polyline.boundingMapRect            //  zoom in your opening position
            self.mapKitView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
            
        })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 5.0
        return renderer
    }
    
}





