//
//  MapViewController.swift
//  swiftfinal
//
//  Created by user272224 on 4/29/25.
//
import CoreData
import Foundation
import UIKit
import MapKit
class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    var locationManager =  CLLocationManager()
    var favorites:[Favorite] = []
    @IBOutlet weak var sgmtMapType: UISegmentedControl!
    
    @IBAction func mapTypeChanged(_ sender: Any) {
        switch sgmtMapType.selectedSegmentIndex {
               case 0:
                   mapView.mapType = .standard
               case 1:
                   mapView.mapType = .satellite
               case 2:
                   mapView.mapType = .hybrid
               default:
                   break
               }    }
    override func viewWillAppear(_ animated: Bool) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
            var fetchedObjects: [NSManagedObject] = []
            
            do {
                fetchedObjects = try context.fetch(request)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
        favorites = fetchedObjects as! [Favorite]
            self.mapView.removeAnnotations(self.mapView.annotations)

        for favorite in favorites {
                let address = "\(favorite.streetAddress!), \(favorite.city!) \(favorite.state!)"
                let geoCoder = CLGeocoder()
                geoCoder.geocodeAddressString(address) { (placemarks, error) in
                    self.processAddressResponse(favorite, withPlacemarks: placemarks, error: error)
                }
            }
        }
    
    private func processAddressResponse(_ favorite: Favorite, withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
              if let error = error {
                  print("Geocoder error: \(error)")
              } else {
                  var bestMatch: CLLocation?
                  if let placemarks = placemarks, placemarks.count > 0 {
                      bestMatch = placemarks.first?.location
                  }
                  if let coordinate = bestMatch?.coordinate {
                      let mp = MapPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
                      mp.title = favorite.detail // double check with ethan this is right value
                      mp.subtitle = favorite.streetAddress
                      mapView.addAnnotation(mp)
                  } else {
                      print("didn't find any matching locations")
                  }
              }
          }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBAction func findUser(_ sender: Any) {
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
               mapView.removeAnnotations(mapView.annotations)
               var span = MKCoordinateSpan()
               span.latitudeDelta = 0.2
               span.longitudeDelta = 0.2
               let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, span: span)
               mapView.setRegion(viewRegion, animated: true)
               let mp = MapPoint(latitude: userLocation.coordinate.latitude,
                                 longitude: userLocation.coordinate.longitude)
               mp.title = "You"
               mp.subtitle = "Are here"
               mapView.addAnnotation(mp)
           }
}
