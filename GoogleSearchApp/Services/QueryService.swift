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
    
    private let id = "005201719826685222043:s3meep7wm6m"
    private let apiKey = "AIzaSyDBBxKBdfvPKtx_jTqiy8HxVsWDDt7ly28"
    private var url = URL(string: "https://www.googleapis.com/customsearch/v1?")
    var dataTask: URLSessionDataTask?
    
    typealias JSONDictionary = [String: Any]
    
    func getData(with query: String, completion: @escaping ([GoogleResponse]?, NSError?) -> ()) {
        guard let requestURL = createURL(request: query) else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if (error != nil) {
                completion(nil, error as NSError?)
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
            do {
                response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
            } catch let parseError as NSError {
                print(parseError)
            }
            guard let array = response!["items"] as? [Any] else { return }
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
    
    func alert(view: UIViewController, message: String) {
        let alert = UIAlertController(title: "Error", message: "Connection error: " + message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in })
        alert.addAction(defaultAction)
        DispatchQueue.main.async(execute: {
            view.present(alert, animated: true)
        })
    }
    
    func createURL(request: String) -> URL? {
        guard let url = url,
            var componentsURL = URLComponents(string: url.absoluteString) else { return nil }
        
        componentsURL.queryItems = [
            URLQueryItem(name: "q", value: request),
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "cx", value: id)
        ]
        
        guard let requestURL = componentsURL.url else { return nil }
        return requestURL
    }
    
    func stop() {
        dataTask?.suspend()
    }
}
