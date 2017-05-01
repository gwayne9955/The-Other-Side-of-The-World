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
    
    let locationManager = CLLocationManager()
    
    @IBAction func antipodeAction(_ sender: AnyObject) {
        //coordinate of the center of the map
        let origin = self.mapView.centerCoordinate
        
        var antipode = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        if (origin.longitude >= 0.0) {
            antipode.longitude = (-1.0)*(180.0 - abs(origin.longitude))
        }
        else{
            antipode.longitude=(180.0 - abs(origin.longitude))
        }
            
        antipode.latitude = (-1.0) * origin.latitude
        
        //and now, center map with new coordinates
        self.mapView.setCenter(antipode, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Location Delegate Methods
    
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

