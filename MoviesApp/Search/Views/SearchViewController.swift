//
//  SearchViewController.swift
//  MoviesApp
//
//  Created by Sakshi Sharma on 2023-07-29.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    var searchController : UISearchController!
    var searchText: String?
    
    //ViewModel Instance
    lazy var viewModel: SearchViewModel = {
        return SearchViewModel(withApiLayer: MovieApiManager())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        setUpSearchBar()
        setUpTableView()
    }
    
    /**
     Method to set up Search Bar as Navigation Title View
     */
    func setUpSearchBar() {
        searchController = UISearchController(searchResultsController:  nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self

        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movie"
        navigationItem.titleView = searchController.searchBar

        self.definesPresentationContext = true
    }
    
    /**
     Method to set up Table View
     */
    func setUpTableView() {
        //Register cell Xib with View Controller
        searchTableView.register(UINib(nibName:"SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        searchTableView.tableFooterView = UIView()
    }
    
    /**
     Initiate Search Api Call
     */
    func initateSearchApiCall(_ withText: String?) {
        if let inputSearch = withText {
            activityIndicatorView.startAnimating()
            viewModel.triggerSearchApiCall(inputSearch)
        }
    }

}

//MARK:- Search Bar Methods
extension SearchViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.endEditing(true)
        
        if var inputText = searchBar.text {
            //Drop White spaces at the end of String
            while inputText.last == " " { inputText = String(inputText.dropLast()) }
            
            //Todo: More checks String encoding properties
            //Replace White spaces between words by "+"
            searchText = inputText.replacingOccurrences(of: " ", with: "+")
            
            //Invoke Api Call on keyboard - Search Button tap
            initateSearchApiCall(searchText)
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell",
                                                       for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        //Set details for the Cell
        DispatchQueue.main.async { [weak self] in

            if let searchData = self?.viewModel.getMovieDetails(indexPath.row),
               let poster = searchData.poster,
               let title = searchData.title,
               let rating = searchData.imdbRating,
               let genres = searchData.genres,
               let genreText = self?.viewModel.mapDetailArray(genres) {
                cell.titleLabel.text = title
                cell.imdbRatingLabel.text = "IMDB: \(rating)"
                cell.genreLabel.text = "Genre: \(genreText)"
                
                if let url = URL(string: poster) {
                    self?.viewModel.getData(from: url) { data, response, error in
                           guard let data = data, error == nil else { return }
                           // always update the UI from the main thread
                           DispatchQueue.main.async() {
                               cell.moviePoster.image = UIImage(data: data)
                           }
                       }
                }
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movieDetails = viewModel.getMovieDetails(indexPath.row) {
            let viewController = DetailsViewController(nibName: "DetailsViewController", bundle: Bundle.main)
            viewController.movieDetails = movieDetails
            navigationController?.pushViewController(viewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}


extension SearchViewController: SearchViewControllerProtocol {
    /**
     Refresh data for Search Table View
     */
    func refreshData() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicatorView.stopAnimating()
            self?.searchTableView.isHidden = false
            self?.searchTableView.reloadData()
        }
    }
    
    /**
     Handle Error prompt
     */
    func handleErrorPrompt(_ message: String) {
         DispatchQueue.main.async { [weak self] in
            
            self?.activityIndicatorView.stopAnimating()
            
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    
            let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                print("Default tapped")
            }
            alertController.addAction(okAction)
            self?.present(alertController, animated: true, completion: nil)
        }
    }
}
