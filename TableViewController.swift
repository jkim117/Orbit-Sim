//
//  TableViewController.swift
//  Orbit Sim
//
//  Created by jason kim on 2/5/17.
//  Copyright © 2017 jason kim. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var array = ["Mercury", "Venus", "Earth", "Mars", "Asteroid 2002 KL6"]
    var aValues = ["0.3870982252717257","0.7233268496749391","1.000371833989169","1.523678184302188","2.307355347325137"]
    var eValues = ["0.2056302512089075","0.006755697267164094","0.01704239716781501","0.09331460653723893","0.5503472901025839"]
    var oValues = ["48.33053756455964","76.67837563371675","163.9752443600624","49.56199966373916","215.1657829181022"]
    var iValues = ["7.005014199657344","3.394589632336535","0.0002669113820737183","1.849876609221010","3.233604543786646"]
    var wValues = ["29.12428058698772","55.18541455452200","297.7668064579176","286.5373577554387","95.74741833716503"]
    var mValues = ["172.7497133778637","49.31425178852966","358.1891404220149","19.09450886999620","98.72778265595174"]
    var currentPlanet = 0

          @IBOutlet weak var tableO: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = array[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destVC = segue.destination as! DetailsViewController
                destVC.aText = aValues[indexPath.row]
                destVC.eText = eValues[indexPath.row]
                destVC.oText = oValues[indexPath.row]
                destVC.iText = iValues[indexPath.row]
                destVC.wText = wValues[indexPath.row]
                destVC.mText = mValues[indexPath.row]
                destVC.currentPlanet = indexPath.row
                currentPlanet = indexPath.row
            }
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
