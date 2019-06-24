//
//  ViewController.swift
//  GoogleSearchApp
//
//  Created by Dima Shelkov on 6/24/19.
//  Copyright © 2019 Dima Shelkov. All rights reserved.
//

import UIKit

class GoogleSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var googSearchleTextField: UITextField!
    @IBOutlet weak var googleSearchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        cell.textLabel?.text = "aaa"
        return cell
    }
}

