//
//  ViewController.swift
//  GoogleSearchApp
//
//  Created by Dima Shelkov on 6/24/19.
//  Copyright © 2019 Dima Shelkov. All rights reserved.
//

import UIKit
class GoogleSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var googleSearchleTextField: UITextField!
    @IBOutlet weak var googleSearchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var isSearching = false { didSet { searchPressed() }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        QueryService.shared.getData(with: googleSearchleTextField.text!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QueryService.shared.responses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        updateCell(cell: cell, index: indexPath.item)
        return cell
    }
    
    func updateCell(cell: UITableViewCell, index: Int) {
//        guard !networking.responses.isEmpty else { return }
//        let item = networking.responses[index]
//        cell.textLabel?.text = item.title
//        cell.detailTextLabel?.text = item.displayLink
    }
    
    func searchPressed() {
        if isSearching == true {
            googleSearchButton.setTitle("Stop", for: .normal)
            googleSearchButton.backgroundColor = .red
        } else {
            googleSearchButton.setTitle("Google Search", for: .normal)
            googleSearchButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        }
        googleSearchleTextField.text? = ""
    }
    
    func search() {
        isSearching = !isSearching
    }
}

