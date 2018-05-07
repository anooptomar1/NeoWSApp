//
//  ViewController.swift
//  NeoWSApp
//
//  Created by a27 on 2018-05-03.
//  Copyright © 2018 a27. All rights reserved.
//

import UIKit
import SVProgressHUD

class StartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - API Keys and API Url's
    let nasaKey = "mxYfugT2OQg976YfLCiansy1TbqxmdhdqGDb2P37"
    //    let feedToday = "https://api.nasa.gov/neo/rest/v1/feed/today?detailed=true&api_key="
    let feed = "https://api.nasa.gov/neo/rest/v1/feed?start_date=2018-05-04&end_date=2018-05-04&api_key="
    
    
    //MARK: - Variables
    @IBOutlet weak var startTableView: UITableView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var myConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var constraint: NSLayoutConstraint!
    var listOfAsteroids = [Asteroid]()
    
    //MARK: - StartUp functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataStartTableView(notification:)), name: .doneParsing, object: nil)
        
        //Test for FetchData Class
        
        let test = FetchData()
        test.fetchData(url: "\(feed)\(nasaKey)")
        
    }
    
    // MARK: - Notification
    
    @objc func reloadDataStartTableView(notification: NSNotification) {
        startTableView.reloadData()
        SVProgressHUD.dismiss()
    }
    
    //MARK: - Buttons
    @IBAction func searchBtnPressed(_ sender: UIBarButtonItem) {
        
       
        self.dateView.frame.size.height = 360
        //self.constraint.constant = 300
        view.layoutIfNeeded()
        
        
     //   UIView.animate(withDuration: 2.0){
        
       // }
        
        
    }
    
    //MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if !AsteroidBank.listOfAsteroids.isEmpty {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
            tableView.rowHeight = 140
            tableView.isScrollEnabled = true
            
        } else {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No asteroid data available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            tableView.isScrollEnabled = false
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AsteroidBank.listOfAsteroids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CustomCell", owner: self, options: nil)?.first as! CustomCell
        
        let asteroid = AsteroidBank.listOfAsteroids[indexPath.row]
        
        cell.nameLabel.text = "\(asteroid.name)"
        if asteroid.size > 999 {
            cell.sizeLabel.text =  String(format: "%.2f km", asteroid.size/1000)
        } else {
            cell.sizeLabel.text = String(format: "%.0f m", asteroid.size)
        }
        cell.dangerousLabel.text = "\(asteroid.dangerous)"
        cell.velocityLabel.text = "\(asteroid.velocity) km/s"
        cell.distanceLabel.text = "\(asteroid.missDistance) km"
        cell.orbitingBodyLabel.text = "\(asteroid.orbitingBody)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
}

extension Notification.Name {
    static let doneParsing = Notification.Name("doneParsing")
}
