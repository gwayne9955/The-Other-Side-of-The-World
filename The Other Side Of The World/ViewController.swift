//
//  ViewController.swift
//  The Other Side Of The World
//
//  Created by Garrett Wayne on 4/30/17.
//  Copyright © 2017 Garrett Wayne. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentLocationOutlet: UINavigationItem!
    
    let locationManager = CLLocationManager()
    var antipode = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    @IBAction func antipodeAction(_ sender: Any) {
        // Coordinate of whatever the center of the map is
        let origin = self.mapView.centerCoordinate
        
        // Antipode calculations
        if (origin.longitude >= 0.0) {
            antipode.longitude = (-1.0)*(180.0 - abs(origin.longitude))
        }
        else{
            antipode.longitude=(180.0 - abs(origin.longitude))
        }
        antipode.latitude = (-1.0) * origin.latitude
        
        // Now, center map with new coordinates
        self.mapView.setCenter(antipode, animated: true)
        currentLocationOutlet.title = "Current Antipode"
        
        // Clear any possible previous annotations
        self.mapView.removeAnnotations(mapView.annotations)
        
        // Add an annotation for the new other side of the world
        let annotation = MKPointAnnotation()
        annotation.coordinate = antipode
        annotation.title = "The Other Side of the World"
        self.mapView.addAnnotation(annotation)
    }
    
    @IBAction func recenterAction(_ sender: Any) {
        getCurrentLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentLocationOutlet.prompt = "Welcome to the Other Side of the World!"
        getCurrentLocation()
    }
    
    func getCurrentLocation() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        currentLocationOutlet.title = "Current Location"
        
        // Clear any possible previous annotations
        self.mapView.removeAnnotations(mapView.annotations)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Location Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors: " + error.localizedDescription)
    }
}

