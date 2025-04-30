//
//  FavoriteViewController.swift
//  swiftfinal
//
//  Created by My Dang on 4/29/25.
//

import UIKit
import CoreLocation

class FavoriteViewController: UIViewController, CLLocationManagerDelegate{
    
    var currentFavorite: Favorite?
    var locationManager = CLLocationManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var geoCoder = CLGeocoder()


    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var sgmntEditMode: UISegmentedControl!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtDetail: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var textCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
               let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
               view.addGestureRecognizer(tap)
               
               locationManager = CLLocationManager()
               locationManager.delegate = self
               locationManager.requestWhenInUseAuthorization()
        // Do any additional setup after loading the view.
    }
    //handle errors from permissions/general errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            let errorType = error._code == CLError.denied.rawValue ? "Location Permission Denied" : "Unknown Error"
            let alertController = UIAlertController(title: "Error getting location: \(errorType)",
                                                    message: "Error Message: \(error.localizedDescription)",
                                                    preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "OK",
                                         style: .default,
                                         handler: nil)
            alertController.addAction(actionOK)
            present(alertController, animated: true, completion: nil)
        }
    
    // ask for perms
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
            if status == .authorizedWhenInUse{
                print("Permission granted")
            }
            else {
                print("Permission not granted")
            }
        }
        
    @IBAction func currentLocationToAddress(_ sender: Any) {
        locationManager.requestLocation()
    }
    //uses placemarks to fill the address fields
    private func processAddressResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            print("Geocode error: \(error)")
        } else if let placemark = placemarks?.first {
            txtStreet.text = placemark.thoroughfare ?? ""
            textCity.text = placemark.locality ?? ""
            txtState.text = placemark.administrativeArea ?? ""
        } else {
            print("Didn't find any matching locations")
        }
    }
//uses the most recent location to reverse geocode and fill address fields
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let eventDate = location.timestamp
            let howRecent = eventDate.timeIntervalSinceNow
            if Double(howRecent) < 15.0 {
                geoCoder.reverseGeocodeLocation(location) { placemarks, error in
                    self.processAddressResponse(withPlacemarks: placemarks, error: error)
                }
            }
        }
    }

    @IBAction func changeEditMode(_ sender: Any) {
        let textFields: [UITextField] = [txtLocation, txtDetail, txtStreet, textCity, txtState, txtZip]
        if sgmntEditMode.selectedSegmentIndex == 0{
            for textField in textFields{
                textField.isUserInteractionEnabled = false
                textField.borderStyle = UITextField.BorderStyle.none
            }
            imageButton.isHidden = true
            navigationItem.rightBarButtonItem = nil
        }
        else if sgmntEditMode.selectedSegmentIndex == 1{
            for textField in textFields{
                textField.isUserInteractionEnabled = true
                textField.borderStyle = UITextField.BorderStyle.bezel
            }
            imageButton.isHidden = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveFavorite))
        }
    }
    @objc func saveFavorite(){
        appDelegate.saveContext()
        sgmntEditMode.selectedSegmentIndex = 0
        changeEditMode(self)
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool{
        if currentFavorite == nil{
            let context = appDelegate.persistentContainer.viewContext
            currentFavorite = Favorite(context: context)
        }
        currentFavorite?.location = txtLocation.text
        currentFavorite?.detail = txtDetail.text
        currentFavorite?.streetAddress = txtStreet.text
        currentFavorite?.city = textCity.text
        currentFavorite?.state = txtState.text
        currentFavorite?.zipcode = txtZip.text
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardNotifications()
    }

    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(FavoriteViewController.keyboardDidShow(notification:)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(FavoriteViewController.keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardDidShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardSize = keyboardFrame.cgRectValue.size

        var contentInset = self.scrollView.contentInset
        contentInset.bottom = keyboardSize.height

        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = contentInset
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = 0

        self.scrollView.contentInset = contentInset
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @objc func dismissKeyboard(){
           view.endEditing(true)
       }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
