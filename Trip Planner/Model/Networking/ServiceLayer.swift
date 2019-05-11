//
//  ServiceLayer.swift
//  Trip Planner
//
//  Created by Stephen Ouyang on 5/8/19.
//  Copyright © 2019 Stephen Ouyang. All rights reserved.
//

import Foundation

enum NetworkingError: Error {
    
    case badURL
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    
    var localizedDescription: String {
        switch self {
        case .badURL: return "bad URL"
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        }
    }
}

enum Result<T>{
    case success(T)
    case failure(NetworkingError)
}

class ServiceLayer {
    
    //generic class function that is codable (need to pull data from api, convert to object)
    class func request<T: Codable>(router: Router, completion: @escaping (Result<T>) ->()) {
        
//        build url
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.queryItems = router.parameters

        guard let url = components.url else {
            completion(.failure(.badURL))
            return
        }
        print("URL: \(url)")
//        let url = URL(string: "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=Museum%20of%20Contemporary%20Art%20Australia&inputtype=textquery&key=AIzaSyC5HGKLmYXrxGqaQodyMOUgBTPXOfkL2oI")
        
//        create request
        var urlRequest = URLRequest(url: url)
        //specify request method
        urlRequest.httpMethod = router.method
        
        //create session
        let session = URLSession(configuration: .default)
        //create data task
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            }
            
            if httpResponse.statusCode != 200 {
                print("status code: \(httpResponse.statusCode)")
                completion(.failure(.responseUnsuccessful))
            }
            
            if let responseData = data {
                print("DATA: \(responseData)")
                do {
                    let responseObj = try JSONDecoder().decode(T.self, from: responseData)
                    
                    completion(.success(responseObj))
                } catch {
                    completion(.failure(.jsonConversionFailure))
                }
            } else {
                completion(.failure(.invalidData))
            }
        }
        dataTask.resume()
    }
}
