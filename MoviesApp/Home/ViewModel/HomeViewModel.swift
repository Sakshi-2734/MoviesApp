

import UIKit

protocol HomeViewModelProtocol {
    associatedtype MovieApiLayer
    init(withApiLayer apiLayer: MovieApiLayer)
}

protocol HomeViewControllerProtocol: AnyObject {
    func refreshData()
    func handleErrorPrompt(_ message: String)
}

class HomeViewModel: NSObject, HomeViewModelProtocol {
    
    let apiLayer: MovieApiProtocol
    
    var movies: MoviesModel?
    
    //Map dictionary into tableView representable data
    var genreDict: [String: [MovieDetailModel]] = [:]
    var genreData:[(key:String,values:[MovieDetailModel])]?

    //Error handling
    var alertMessage: NSString?
    
    weak var delegate: HomeViewControllerProtocol?
    
    required init(withApiLayer apiLayer:MovieApiProtocol = MovieApiManager()) {
        self.apiLayer = apiLayer
    }
    
    //MARK: - Api Call triggers
    func triggerMovieCall() {
        self.apiLayer.invokeMovieApiCall { [weak self] (result, error) in
            if let error = error {
                //Added a Local String for Unit Test case.
                self?.alertMessage = (error.localizedDescription) as NSString
                self?.delegate?.handleErrorPrompt(error.localizedDescription)
            }
            
            if let movieResult = result {
                self?.movies = movieResult
                self?.mapGenreDict()
                self?.delegate?.refreshData()
            }
        }
    }
    
    //MARK:- TableView Wrapper Methods
    
    /**
     Map Genre Dict for Table view dataSource
     */
    func mapGenreDict() {
        if let moviesData = movies, let movies = moviesData.movies {
            for movie in movies {
                if let genres = movie.genres {
                    for genre in genres {
                        if genreDict[genre] == nil {
                            genreDict[genre] = [movie]
                        } else {
                            if var genreMovies = genreDict[genre] {
                                genreMovies.append(movie)
                                genreDict.removeValue(forKey: genre)
                                genreDict[genre] = genreMovies
                            }
                        }
                    }
                }
            }
            //Tableview DataSource mapping - With Sorted Dict
            genreData = genreDict.compactMap({(key:$0,values:$1)}).sorted(by: { (genreItem1, genreItem2) -> Bool in
                return genreItem1.key < genreItem2.key
            })
        }
    }
    
    func getNumberOfRows() -> Int {
        return genreData?.count ?? 0
    }
    
    /**
       CellForRow - Get Movie Object for given indexPath row
     */
    func getMovieObject(_ index: Int) -> (genre: String, movies: [MovieDetailModel])? {
        if let genre = genreData?[index].key, let movies = genreData?[index].values {
             return (genre, movies)
        }
        return nil
    }
    
    /**
     Map Movie Details for the selected Movie item in Genre
     */
    func getMovieDetails(_ genre: Int, _ index: Int) -> MovieDetailModel? {
        if let movieDetails = getMovieObject(genre) {
            return movieDetails.movies[index]
        }
        return nil
    }
}
