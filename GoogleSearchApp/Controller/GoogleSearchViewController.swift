//
//  ViewController.swift
//  GoogleSearchApp
//
//  Created by Dima Shelkov on 6/24/19.
//  Copyright © 2019 Dima Shelkov. All rights reserved.
//

import UIKit

class GoogleSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var responsesViewModels = [ResponseViewModel]()
    var isSearching = false { didSet { searchPressed() }}
    
    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var googleSearchleTextField: UITextField!
    @IBOutlet weak var googleSearchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(activityIndicatorView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        responsesViewModels.removeAll()
        if !isSearching {
            QueryService.shared.getData(with: googleSearchleTextField.text!) { (responses, error) in
                if let error = error {
                    QueryService.shared.alert(view: self, message: error.localizedDescription)
                }
                self.responsesViewModels = responses?.map({ return ResponseViewModel(response: $0) }) ?? []
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.changeSearchState()
                }
            }
        } else if isSearching {
            QueryService.shared.stop()
        }
        changeSearchState()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responsesViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        let response = responsesViewModels[indexPath.row]
        updateCell(cell, from: response)
        return cell
    }
    
    func updateCell(_ cell: UITableViewCell, from response: ResponseViewModel) {
        cell.textLabel?.text = response.title
        cell.detailTextLabel?.text = response.link
    }
    
    private func searchPressed() {
        if isSearching == true {
            googleSearchButton.setTitle("Stop", for: .normal)
            googleSearchButton.backgroundColor = .red
            activityIndicatorView.isHidden = false
            activityIndicator.startAnimating()
        } else {
            googleSearchButton.setTitle("Google Search", for: .normal)
            googleSearchButton.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            activityIndicator.stopAnimating()
            activityIndicatorView.isHidden = true
        }
        googleSearchleTextField.text? = ""
    }
    
    private func changeSearchState() {
        isSearching = !isSearching
    }
}
    

