//
//  SearchViewModel.swift
//  MoviesApp
//
//  Created by Sakshi Sharma on 2023-07-29.
//

import UIKit

protocol SearchViewModelProtocol {
    associatedtype MovieApiLayer
    init(withApiLayer apiLayer: MovieApiLayer)
}

protocol SearchViewControllerProtocol: AnyObject {
    func refreshData()
    func handleErrorPrompt(_ message: String)
}

class SearchViewModel: NSObject, SearchViewModelProtocol {
    
    let apiLayer: SearchApiProtocol
    
    weak var delegate: SearchViewControllerProtocol?
    
    var alertMessage: NSString?
    var moviesData: MoviesModel?
    
    required init(withApiLayer apiLayer: SearchApiProtocol = MovieApiManager()) {
        self.apiLayer = apiLayer
    }

    //Search Api Call - for given Search content and page index
    func triggerSearchApiCall(_ searchContent:String?) {
        self.apiLayer.invokeSearchApiCall(searchContent) { [weak self] (result, error) in
            if let error = error {
                //Added a Local String for Unit Test case.
                self?.alertMessage = (error.localizedDescription) as NSString
                self?.delegate?.handleErrorPrompt(error.localizedDescription)
            }
            
            if let movieResult = result {
                self?.moviesData = movieResult
                if let movies = movieResult.movies, movies.count > 0 {
                    self?.delegate?.refreshData()
                } else {
                    self?.delegate?.handleErrorPrompt("No Results found! Please try again")
                }
            }
        }
    }
    
    //MARK:- TableView Wrapper Methods
    func getNumberOfRows() -> Int {
        guard let resultCount = moviesData?.movies?.count else { return 0 }
        return resultCount
    }
    
    func getMovieDetails(_ index: Int) -> MovieDetailModel? {
        if let movies = moviesData?.movies {
            let movieModel = movies[index]
            return movieModel
        }
        return nil
    }
    
    func mapDetailArray(_ names: [String]) -> String? {
        var nameString = names.first
        for index in 1..<names.count {
            nameString?.append(", \(names[index])")
        }
        return nameString
    }
    
    /**
     Download image data from URL
     */
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
