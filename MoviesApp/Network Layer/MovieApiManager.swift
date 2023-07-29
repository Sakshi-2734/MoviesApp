//
//  MovieApiManager.swift
//  MoviesApp
//
//  Created by Sakshi Sharma on 2023-07-23.
//

import UIKit

typealias CompletionBlock = (_ result: MoviesModel?, _ error: Error?) -> Void

protocol MovieApiProtocol {
    func invokeMovieApiCall(_ completion: @escaping CompletionBlock)
}

protocol SearchApiProtocol {
    func invokeSearchApiCall(_ searchText:String?, _ completion: @escaping CompletionBlock)
}

class MovieApiManager: NSObject, MovieApiProtocol, SearchApiProtocol {
    
    /**
     Api Call - Fetch All Movies details using Base Url
     */
    func invokeMovieApiCall(_ completion: @escaping CompletionBlock) {
//        guard let bundlePath = Bundle.main.path(forResource: "Info", ofType: "plist"),
//            let content = FileManager.default.contents(atPath: bundlePath),
//            let preferences = try? PropertyListDecoder().decode(BaseUrl.self, from: content) else {
//            return
//        }
        
        let session = URLSession.shared
        let urlString: String = "https://wookie.codesubmit.io/movies"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer Wookie2019", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
                completion(nil, error)
            }
            
            guard let data = data as Data? else {
               print("Error: Data is nil")
               return
            }
            
            //Debug - Json response
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
            
            //JSON Decoder to handle parsing and mapping to Model Class
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let apiData = try decoder.decode(MoviesModel.self, from: data)
                completion(apiData, nil)
            } catch let error {
                print("Parsing Error")
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    /**
     Api Call - Search movie details based upon input Search string
     TODO: Reusable dataTask
     */
    func invokeSearchApiCall(_ searchText:String?, _ completion: @escaping CompletionBlock) {
        guard let bundlePath = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let content = FileManager.default.contents(atPath: bundlePath),
            let preferences = try? PropertyListDecoder().decode(BaseUrl.self, from: content),
            let movieName = searchText else {
            return
        }
        
        let session = URLSession.shared
        let urlString: String = "\(preferences.searchBaseUrl)\(movieName)"
    
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(preferences.movieAuthorizationKey, forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
                completion(nil, error)
            }
            
            guard let data = data as Data? else {
               print("Error: Data is nil")
               return
            }
            
            //JSON Decoder to handle parsing and mapping to Model Class
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let apiData = try decoder.decode(MoviesModel.self, from: data)
                completion(apiData, nil)
            } catch let error {
                print("Parsing Error")
                completion(nil, error)
            }
        }
        task.resume()
    }
}
