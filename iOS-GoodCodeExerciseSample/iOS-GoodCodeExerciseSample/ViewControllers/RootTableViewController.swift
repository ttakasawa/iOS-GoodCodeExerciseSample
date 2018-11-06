//
//  RootTableViewController.swift
//  iOS-GoodCodeExerciseSample
//
//  Created by Tomoki Takasawa on 11/5/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

struct DashboardData: Codable {
    var id: String
    var material: ApplicationMaterial
    var name: String
    var url: String
    
    var icon: UIImage {
        return self.material.iconImage
    }
    
    var themeColor: UIColor {
        return self.material.backgroundColor
    }
    
}


class RootTableViewController: UITableViewController {
    
    var cellData: [DashboardData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(DashboardCell.self, forCellReuseIdentifier: "Dashboard")
        self.tableView.separatorStyle = .none

        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Tomoki Takasawa"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configure(){
        
        Global.network.queryUser(userId: "id") { (user: UserData?, error: Error?) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }else{
                guard let applicationMaterials = user?.userApplicationMaterial else { return }
                self.cellData = applicationMaterials
            }
            self.tableView.reloadData()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Dashboard", for: indexPath) as! DashboardCell

        //cell.imageView.setima
        cell.iconImage = self.cellData[indexPath.row].icon.withRenderingMode(.alwaysTemplate)
        cell.iconImageView.tintColor = .white
        
        cell.selectionStyle = .none
        cell.backgroundColor = self.cellData[indexPath.row].material.backgroundColor
        cell.layoutSubviews()
        
        return cell
    }

 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = self.cellData[indexPath.row]
        
        if let navigator = self.navigationController {
            let vc = DetailViewController(stringUrl: cell.url, name: cell.name, themeColor: cell.themeColor, logo: cell.icon)
            navigator.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

