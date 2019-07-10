//
//  QueryService.swift
//  GoogleSearchApp
//
//  Created by Dima Shelkov on 6/27/19.
//  Copyright © 2019 Dima Shelkov. All rights reserved.
//

import Foundation

class QueryService {
    static let shared = QueryService()
    
    typealias JSONDictionary = [String: Any]
    let id = "005201719826685222043:s3meep7wm6m"
    let apiKey = "AIzaSyDBBxKBdfvPKtx_jTqiy8HxVsWDDt7ly28"
    
//
//    var dataTask: URLSessionDataTask?
//    let defaultSession = URLSession(configuration: .default)
    var errorMessage = ""
//
    var responses = [GoogleResponse]()
    
    func getData(with query: String) {
        let string = "https://www.googleapis.com/customsearch/v1?key=\(apiKey)&cx=\(id)&q=\(query)"
        let searchURL = URL(string: string)!
        
        var request = URLRequest(url: searchURL)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if (error != nil) {
                print(error ?? "Error is empty.")
            } else if let httpResponse = response as? HTTPURLResponse,
                let responseData = data,
                httpResponse.statusCode == 200 {
                
                self.updateSearchResults(responseData)
            }
            
            //            guard let responseData = data else {
            //                print("Error: did not receive data")
            //                return
            //            }
            
            //            do {
            //                print(responseData)
            //
            ////                let searchData = try JSONDecoder().decode(MyWeather.self, from: responseData)
            ////                let ggtemp = weatherData.main?.temp
            ////                print(ggtemp, "THIS IS THE TEMP")
            ////                DispatchQueue.main.async {
            ////                    tempDisplay.text = String (ggtemp) + " c"
            ////                }
            //
            //            } catch  {
            //                print("error parsing response from POST on /todos")
            //                return
            //            }
        }
        
        dataTask.resume()
    }
    
    fileprivate func updateSearchResults(_ data: Data) {
        var response: JSONDictionary?
        responses.removeAll()
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let array = response!["items"] as? [Any] else {
            errorMessage += "Dictionary does not contain results key\n"
            return
        }
        
        for data in array {
            if let response = data as? JSONDictionary,
                let title = response["title"] as? String,
                let subtitle = response["link"] as? String {
                responses.append(GoogleResponse(displayLink: subtitle, title: title))
            }
        }
        print(responses)
    }
    
//    func getSearchResults(with query: String, completion: @escaping ([GoogleResponse]?, String) -> ()) {
//
//        dataTask?.cancel()
//
//        let id = "005201719826685222043:s3meep7wm6m"
//        let apiKey = "AIzaSyDBBxKBdfvPKtx_jTqiy8HxVsWDDt7ly28"
//        let stringURL = "https://www.googleapis.com/customsearch/v1?key=\(apiKey)&cx=\(id)&q=\(query)"
//
//        guard var urlComponents = URLComponents(string: "https://www.googleapis.com/customsearch/v1?") else { return }
//        urlComponents.query = "key=\(apiKey)&cx=\(id)&q=\(query)"
//        guard let myURL = urlComponents.url else { return }
//
//        //        guard let myURL = URL(string: stringURL) else { return }
//
//        dataTask = defaultSession.dataTask(with: myURL) { data, response, error in
//            defer { self.dataTask = nil }
//            // 5
//            if let error = error {
//                self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
//            } else if let data = data,
//                let response = response as? HTTPURLResponse,
//                response.statusCode == 200 {
//                print(data)
//                //                self.updateSearchResults(data)
//                // 6
//                DispatchQueue.main.async {
//                    completion(self.responses, self.errorMessage)
//                }
//            }
//
//        }
//        dataTask?.resume()
//    }
//        let request = URLRequest(url: myURL)
//        request.httpMethod = "GET"  //allHTTPHeaderFields = ["key": apiKey, "cx": id, "q": query]
        
//        dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) in
//            print(data)
//            print(response)
//            print(error)
//
//            DispatchQueue.main.async {
//                completion(self.responses)
//            }
//        })
//    }
    

    
//    func showAlert(with error: Error) {
//        let alert = UIAlertController(title: "Error: ", message: "Connection error: \(error)", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
////        delegate!.present(alert, animated: true)
//    }
    
}
