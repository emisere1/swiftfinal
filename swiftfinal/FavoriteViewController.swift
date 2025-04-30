//
//  FavoriteViewController.swift
//  swiftfinal
//
//  Created by My Dang on 4/29/25.
//

import UIKit
import CoreLocation
import CoreData
import AVFoundation
import Photos

class FavoriteViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & CLLocationManagerDelegate, UINavigationControllerDelegate{
    lazy var geoCoder = CLGeocoder()
    var currentFavorite: Favorite?
    var locationManager = CLLocationManager()
    var favorites:[Favorite] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    

    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var sgmntEditMode: UISegmentedControl!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtDetail: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var textCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    
    @IBOutlet weak var imageFav: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
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
            let status = CLLocationManager.authorizationStatus()

                if status == .notDetermined {
                    locationManager.requestWhenInUseAuthorization()
                } else if status == .authorizedWhenInUse || status == .authorizedAlways {
                    locationManager.requestLocation()
                } else {
                    let alert = UIAlertController(title: "Location Access Denied",
                                                  message: "Please enable location access in Settings.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
         locationManager.desiredAccuracy = kCLLocationAccuracyBest

         // REQUEST LOCATION PERMISSION
         locationManager.requestWhenInUseAuthorization()
        
        if currentFavorite != nil{
            txtLocation.text = currentFavorite!.location
            txtDetail.text = currentFavorite!.detail
            txtStreet.text = currentFavorite!.streetAddress
            textCity.text = currentFavorite!.city
            txtState.text = currentFavorite!.state
            txtZip.text = currentFavorite!.state
            if let imageData = currentFavorite?.image as? Data{
                imageFav.image = UIImage(data: imageData)
            }
        }
        
        
        changeEditMode(self)
        let textFields : [UITextField] = [txtLocation,txtDetail, txtStreet, textCity, txtState, txtZip]
        for textfield in textFields{
            textfield.addTarget(self, action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)), for: UIControl.Event.editingDidEnd)
        }

        // Do any additional setup after loading the view.
    }
    @IBAction func changeEditMode(_ sender: Any) {
        let textFields: [UITextField] = [txtLocation, txtDetail, txtStreet, textCity, txtState, txtZip]
        if sgmntEditMode.selectedSegmentIndex == 0{
            for textField in textFields{
                textField.isUserInteractionEnabled = false
                textField.borderStyle = UITextField.BorderStyle.none
            }
            imageFav.isUserInteractionEnabled = false
            imageButton.isHidden = true
            navigationItem.rightBarButtonItem = nil
        }
        else if sgmntEditMode.selectedSegmentIndex == 1{
            for textField in textFields{
                textField.isUserInteractionEnabled = true
                textField.borderStyle = UITextField.BorderStyle.bezel
            }
            imageButton.isHidden = false
            imageFav.isUserInteractionEnabled = true
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveFavorite))
            let press = UILongPressGestureRecognizer.init(target: self, action: #selector(pickPhoto(gesture:)))
            imageFav.addGestureRecognizer(press)
        }
    }
    
    @objc func pickPhoto(gesture: UILongPressGestureRecognizer){
        if PHPhotoLibrary.authorizationStatus() != .authorized {
            let alertController = UIAlertController(title: "Photo Library Access Denied", message: "In order to pick photos, you need to allow the app to access the Photo Library in the Settings", preferredStyle: .alert)
            let actionSettings = UIAlertAction(title: "Open Settings", style: .default){ action in self.openSettings()}
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(actionSettings)
            alertController.addAction(actionCancel)
            present(alertController, animated: true, completion: nil)        }
        else{
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
            }
        print("Button Works")}
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
    

    @IBAction func takePhoto(_ sender: Any) {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) != AVAuthorizationStatus.authorized{
            let alertController = UIAlertController(title: "Camera Access Denied", message: "In order to take pictures, you need to allow the app to access the camera in Settings", preferredStyle: .alert)
            let actionSettings = UIAlertAction(title: "Open Settings", style: .default){ action in self.openSettings()}
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(actionSettings)
            alertController.addAction(actionCancel)
            present(alertController, animated: true, completion: nil)
        }
        else{
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let cameraController = UIImagePickerController()
                cameraController.sourceType = .camera
                cameraController.cameraCaptureMode = .photo
                cameraController.delegate = self
                cameraController.allowsEditing = true
                self.present(cameraController, animated: true, completion: nil)
                
            }
        }
    }
    
    func openSettings(){
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString){
            if #available(iOS 10.0, *){
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }else{
                UIApplication.shared.openURL(settingsUrl)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage{
            imageFav.contentMode = .scaleAspectFit
            imageFav.image = image
            
            if currentFavorite == nil {
                let context = appDelegate.persistentContainer.viewContext
                currentFavorite = Favorite(context: context)
            }
            currentFavorite?.image = image.jpegData(compressionQuality: 1.0)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard(){
               view.endEditing(true)
           }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
