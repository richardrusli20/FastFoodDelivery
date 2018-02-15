//
//  DeliveryViewController.swift
//  FastFoodDelivery
//
//  Created by Richard Rusli on 6/06/2017.
//  Copyright © 2017 Richard. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class DeliveryViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet var mapV: MKMapView!
    let manager = CLLocationManager()
    var destination : MKMapItem?
    var userLocation :CLLocation?
    
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet var estTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //delegate controller
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        mapV.delegate = self
        mapV.showsUserLocation = true
        mapV.showsScale = true
        mapV.showsPointsOfInterest = true
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        userLocation = locations[0]

            self.getDirections()
        
        
    }
    
    func getDirections() {
        
        let sourceCoordinates = manager.location?.coordinate
        let destCoordinates = CLLocationCoordinate2DMake(-37.8764093, 145.041556)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinates!)
        let destPlacemark = MKPlacemark(coordinate: destCoordinates)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        
        let request = MKDirectionsRequest()
        request.source = sourceItem
        request.destination = destItem
        request.transportType = .automobile
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        
        directions.calculate(completionHandler: {(response, error) in
            
            if error != nil {
                print("Error getting directions")
            } else {
                self.showRoute(response: response!)
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }

    

    
    
    func showRoute(response: MKDirectionsResponse) {
        
        for route in response.routes {
            
            mapV.add(route.polyline,
                         level: MKOverlayLevel.aboveRoads)
            
            
            // show the estimated time using a car from the source to destinated place
            self.estTime.text = "\(String(format: "%.0f",route.expectedTravelTime.rounded()/60)) minutes"

        }
        
        let region = MKCoordinateRegionMakeWithDistance(userLocation!.coordinate,
                                               3000, 3000)
        mapV.setRegion(region, animated: true)
    }
    


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //going back to food list
    @IBAction func goBackToFoodList(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let foodVC = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(foodVC, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
