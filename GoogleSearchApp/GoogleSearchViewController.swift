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
    
    var items = [GoogleResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        guard let text = googSearchleTextField.text else { return }
        let request = Networking()
        items = request.makeRequest(with: text)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        updateCell(cell: cell, index: indexPath.item)
        return cell
    }
    
    func updateCell(cell: UITableViewCell, index: Int) {
        guard !items.isEmpty else { return }
        let item = items[index]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.displayLink
    }
}

