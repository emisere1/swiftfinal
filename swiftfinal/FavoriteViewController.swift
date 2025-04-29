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
    

  //  @IBOutlet weak var locationButton: CLLocationButton!
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

        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
