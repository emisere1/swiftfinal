//
//  FavoriteTableViewController.swift
//  swiftfinal
//
//  Created by user270278 on 4/29/25.
//

import UIKit
import CoreData


class FavoriteTableViewControllerr: UITableViewController {
    
  //  var favorites:[NSManagedObject] = []
 //   let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let favorites = ["Atlanta", "Paris", "Sydney"]

    override func viewDidLoad() {
        super.viewDidLoad()
      //  loadDataFromDatabase()
       // self.navigationItem.leftBarButtonItem = self.editButtonItem

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
   /* override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      //  loadDataFromDatabase()
        
        if favorites.isEmpty{
            performSegue(withIdentifier: "AddFavorite", sender: self)
        }else{
            tableView.reloadData()
        }}*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  /*  func loadDataFromDatabase(){
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        do{
            favorites = try context.fetch(request)
        } catch let error as NSError{
            print("Could Not Fetch. \(error), \(error.userInfo)")
        }
    }*/

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath)
     /*   let favorite = favorites[indexPath.row] as? Favorite
        cell.textLabel?.text = favorite?.location
        cell.detailTextLabel?.text = favorite?.city
        cell.accessoryType = UITableViewCell.AccessoryType.detailDisclosureButton*/
        cell.textLabel?.text = favorites[indexPath.row]
        return cell
    }
    
  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditFavorite"{
            let favController = segue.destination as? FavoriteViewController
            let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
            let selectedFav = favorites[selectedRow!] as? Favorite
            favController?.currentFavorite = selectedFav!
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let favorite = favorites[indexPath.row] as? Favorite
            let context = appDelegate.persistentContainer.viewContext
            context.delete(favorite!)
            do {
                try context.save()
            } catch{
                fatalError("Error saving context: \(error)")
            }
            loadDataFromDatabase()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        else if editingStyle == .insert{
            
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFav = favorites[indexPath.row] as? Favorite
        let location = selectedFav!.location
        let actionHandler = {(action:UIAlertAction!) -> Void in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "FavoriteController") as? FavoriteViewController
            controller?.currentFavorite = selectedFav
            self.navigationController?.pushViewController(controller!, animated: true)
        }
        let alertController = UIAlertController(title: "Favorite Selected", message: "Favorite Number \(indexPath.row): \(location!)", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let actionDetails = UIAlertAction(title: "Show Details", style: .default, handler: actionHandler)
        alertController.addAction(actionCancel)
        alertController.addAction(actionDetails)
        present(alertController, animated: true, completion: nil)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */*/

}
