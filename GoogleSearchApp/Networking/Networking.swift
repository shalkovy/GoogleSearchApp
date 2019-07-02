//
//  Networking.swift
//  GoogleSearchApp
//
//  Created by Dima Shelkov on 6/27/19.
//  Copyright © 2019 Dima Shelkov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ProgressHUD

class Networking {
    
    let key = "AIzaSyDBBxKBdfvPKtx_jTqiy8HxVsWDDt7ly28"
    let id = "005201719826685222043:s3meep7wm6m"
    let url = "https://www.googleapis.com/customsearch/v1?"
    
    var responses = [GoogleResponse]()
    var delegate: GoogleSearchViewController?
    var request: DataRequest?
    
    func makeRequest(with query: String) {
        let parameters: [String: String] = ["key": key, "cx": id, "q": query]
        request = Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            
            switch response.result {
            case .success(let data):
                let jsonData = JSON(data)
                let json = jsonData["items"]
                self.makeResponseFromJSONData(json: json)
            case .failure(let error):
                self.showAlert(with: error)
            }
            ProgressHUD.dismiss()
        }
    }
    
    func makeResponseFromJSONData(json: JSON) {
        responses.removeAll()
        json.array?.forEach({ (result) in
            let title = result["title"].stringValue
            let subtitle = result["displayLink"].stringValue
            let response = GoogleResponse(displayLink: subtitle, title: title)
            self.responses.append(response)
            self.delegate?.tableView.reloadData()
        })
    }
    
    func showAlert(with error: Error) {
        let alert = UIAlertController(title: "Error: ", message: "Connection error: \(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        delegate!.present(alert, animated: true)
    }
    
    func cancel() {
        request?.cancel()
        print("CANCEL")
    }
}
