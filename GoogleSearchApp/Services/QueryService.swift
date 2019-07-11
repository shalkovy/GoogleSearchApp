//
//  QueryService.swift
//  GoogleSearchApp
//
//  Created by Dima Shelkov on 6/27/19.
//  Copyright © 2019 Dima Shelkov. All rights reserved.
//

import UIKit

class QueryService {
    static let shared = QueryService()
    var dataTask: URLSessionDataTask?
    
    typealias JSONDictionary = [String: Any]
    private let id = "005201719826685222043:s3meep7wm6m"
    private let apiKey = "AIzaSyDBBxKBdfvPKtx_jTqiy8HxVsWDDt7ly28"
    private var errorMessage = ""

    private var responses = [GoogleResponse]()
    
    func getData(with query: String, completion: @escaping ([GoogleResponse]?, Error?) -> ()) {
        let string = "https://www.googleapis.com/customsearch/v1?key=\(apiKey)&cx=\(id)&q=\(query)"
        let searchURL = URL(string: string)!
        
        var request = URLRequest(url: searchURL)
        request.httpMethod = "GET"
        
        dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if (error != nil) {
                print(error ?? "Error is empty.")
                completion(nil, error)
            } else if let httpResponse = response as? HTTPURLResponse,
                let responseData = data,
                httpResponse.statusCode == 200 {
                completion(self.updateSearchResults(responseData), nil)
            }
        }
        dataTask?.resume()
    }
    
    private func updateSearchResults(_ data: Data) -> [GoogleResponse] {
        var responsesArray = [GoogleResponse]()
        let parseQueue = DispatchQueue.init(label: "parseQueue", qos: .userInitiated, attributes: .concurrent)
        
        parseQueue.sync {
            var response: JSONDictionary?
            self.responses.removeAll()
            
            do {
                response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
            } catch let parseError as NSError {
                self.errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            }
            
            guard let array = response!["items"] as? [Any] else {
                self.errorMessage += "Dictionary does not contain results key\n"
                return
            }
            
            for data in array {
                if let response = data as? JSONDictionary,
                    let title = response["title"] as? String,
                    let subtitle = response["link"] as? String {
                    responsesArray.append(GoogleResponse(displayLink: subtitle, title: title))
                }
            }
        }
        return responsesArray
    }
    
//    func createRequestURL(with request: String) -> URL? {
//        guard let url = stringURL,
//        var urlComponents = URLComponents(string: stringURL.absol)
//    }
    
    func showAlert(with error: Error) {
        let alert = UIAlertController(title: "Error: ", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    }
    
    func stop() {
        dataTask?.suspend()
    }
    
}
