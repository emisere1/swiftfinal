//
//  LocationDemoViewController.swift
//  swiftfinal
//
//  Created by user272224 on 4/29/25.
//

import UIKit

class LocationDemoViewController: UIViewController {

    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblLocationAccuracy: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblHeadingAccuracy: UILabel!
    @IBOutlet weak var lblAltitude: UILabel!
    @IBOutlet weak var lblAltitudeAccuracy: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addressToCoordinates(_ sender: Any) {
    }
    
    @IBAction func deviceCoordinates(_ sender: Any) {
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
