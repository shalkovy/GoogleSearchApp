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

struct Networking {
    
    let key = "AIzaSyDBBxKBdfvPKtx_jTqiy8HxVsWDDt7ly28"
    let customSearchEngineID = "005201719826685222043:s3meep7wm6m"
    let url = "https://www.googleapis.com/customsearch/v1?"
    
    func makeRequest(with query: String)  -> [GoogleResponse] {
        var responses = [GoogleResponse]()
        let parameters: [String: String] = ["key": key, "cx": customSearchEngineID, "q": query]
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                let jsonFormat = JSON(response.result.value!)
                jsonFormat["items"].array?.forEach({ (json) in
                    let title = json["title"].stringValue
                    let subtitle = json["displayLink"].stringValue
                    let responder = GoogleResponse(link: subtitle, title: title)
                    responses.append(responder)
                })
            }
        }
        return responses
    }
}
