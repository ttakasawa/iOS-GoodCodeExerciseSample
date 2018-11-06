//
//  RootTableViewController.swift
//  iOS-GoodCodeExerciseSample
//
//  Created by Tomoki Takasawa on 11/5/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

class RootTableViewController: UITableViewController {
    
    var network: UserNetwork
    var cellData: [ApplicationDisplayable] = []
    
    init (network: SampleNetwork) {
        self.network = network
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        self.tableView.register(DashboardCell.self, forCellReuseIdentifier: "Dashboard")
        self.tableView.separatorStyle = .none

        self.configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGray
        
        let profileButton: UIBarButtonItem = {
            let b = UIBarButtonItem()
            b.image = UIImage(named: "profileLogo")?.withRenderingMode(.alwaysTemplate)
            b.style = .plain
            b.target = self
            b.action = #selector(profilePressed)
            return b
        }()
        
        self.navigationItem.rightBarButtonItem = profileButton
    }
    
    func configure(){
        
        self.network.queryUser(userId: "id") { (user: UserData?, error: Error?) in
            
            if error != nil {
                
                print(error?.localizedDescription ?? "error reading Firebase DB")
                return
                
            }else{
                
                guard let user = user else { return }
                self.network.user = user
                
                self.navigationItem.title = user.name
                self.cellData = user.userApplicationMaterial
                
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
        cell.backgroundColor = self.cellData[indexPath.row].themeColor
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

}

@objc
extension RootTableViewController {
    
    func profilePressed(){
        
        let alert = UIAlertController(title: "Whoops", message: "It seems you do not have access to this.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
