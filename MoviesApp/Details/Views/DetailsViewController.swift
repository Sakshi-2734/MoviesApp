//
//  DetailsViewController.swift
//  MoviesApp
//
//  Created by Sakshi Sharma on 2023-07-29.
//

import UIKit

enum DetailsTableSection: Int {
    case headerSection = 0
    case contentSection
}

enum DetailsRow: Int {
    case year = 0
    case cast
    case description
}

class DetailsViewController: UIViewController {

    @IBOutlet weak var detailsTableView: UITableView!
    var movieDetails: MovieDetailModel?
    
    var detailViewModel = DetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        self.title = movieDetails?.title
    }
    
    func setUpTableView() {
        //Table Cell
        detailsTableView.register(UINib(nibName: "DetailHeaderTableViewCell", bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: "DetailHeaderTableViewCell")
        //Details
        detailsTableView.register(UINib(nibName: "DetailContentTableViewCell", bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: "DetailContentTableViewCell")
        
        detailsTableView.tableFooterView = UIView.init()
    }

}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case DetailsTableSection.headerSection.rawValue:
            return 1
        case DetailsTableSection.contentSection.rawValue:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case DetailsTableSection.headerSection.rawValue:
            return 300
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let details = movieDetails {
            switch indexPath.section {
            case DetailsTableSection.headerSection.rawValue:
                guard let headerCell = tableView.dequeueReusableCell(withIdentifier: "DetailHeaderTableViewCell",
                                                               for: indexPath) as? DetailHeaderTableViewCell else {
                    return UITableViewCell()
                }
                
                if let backDropImage = details.backdrop, let url = URL(string: backDropImage) {
                    detailViewModel.getData(from: url) { data, response, error in
                           guard let data = data, error == nil else { return }
                           // always update the UI from the main thread
                           DispatchQueue.main.async() {
                               headerCell.backdropImageView.image = UIImage(data: data)
                           }
                       }
                }
                
                if let posterImage = details.backdrop, let url = URL(string: posterImage) {
                    detailViewModel.getData(from: url) { data, response, error in
                           guard let data = data, error == nil else { return }
                           // always update the UI from the main thread
                           DispatchQueue.main.async() {
                               headerCell.posterImageView.image = UIImage(data: data)
                           }
                       }
                }
                
                headerCell.movieTitleLabel.text = "\(details.title ?? "") ( IMDB: \(details.imdbRating ?? 0))"
                
                return headerCell
            case DetailsTableSection.contentSection.rawValue:
                guard let contentCell = tableView.dequeueReusableCell(withIdentifier: "DetailContentTableViewCell",
                                                               for: indexPath) as? DetailContentTableViewCell else {
                    return UITableViewCell()
                }
                
                switch indexPath.row {
                case DetailsRow.year.rawValue:
                    if let names = details.director, let releaseString = details.releasedOn {
                        let releaseYear = detailViewModel.mapReleaseYear(releaseString)
                        let directorNames = detailViewModel.mapDetailArray(names)
                        
                        contentCell.contentLabel.text = "\(releaseYear) | \(details.length ?? "") | \(directorNames ?? "")"
                        return contentCell
                    }
                case DetailsRow.cast.rawValue:
                    if let castDetails = details.cast, let cast = detailViewModel.mapDetailArray(castDetails) {
                        contentCell.contentLabel.text = "Cast: \(cast)"
                        return contentCell
                    }
                case DetailsRow.description.rawValue:
                    if let overView = details.overview {
                        contentCell.contentLabel.text = "Storyline: \(overView)"
                        return contentCell
                    }
                default:
                    break
                }
                
            
            default:
                break
            }
            
        }
        
        return UITableViewCell()
    }
}
