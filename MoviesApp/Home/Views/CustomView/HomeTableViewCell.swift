//
//  HomeTableViewCell.swift
//  MoviesApp
//
//  Created by Sakshi Sharma on 2023-07-23.
//
//import Kingfisher
import Foundation
import UIKit
protocol HomeTableViewProtocol: AnyObject {
    func mapSelectedMovieDetail(_ genre: Int, _ movieIndex: Int)
}

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var movieGenreLabel: UILabel!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    var movieDetailModel: [MovieDetailModel]?
    var genreIndex: Int?
    
    weak var cellDelegate: HomeTableViewProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        movieCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMovieDetails(_ details: [MovieDetailModel]?, _ index: Int) {
        if let movies = details {
            movieDetailModel = movies
            genreIndex = index
            movieCollectionView.reloadData()
        }
    }
    
}

extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieDetailModel?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        if let moviePosterString = movieDetailModel?[indexPath.item].poster {
            
            if let url = URL(string: moviePosterString) {
                let processor = DownsamplingImageProcessor(size: cell.movieImageView.bounds.size) |> RoundCornerImageProcessor(cornerRadius: 5)
                cell.movieImageView.kf.indicatorType = .activity
                cell.movieImageView.kf.setImage(
                    with: url,
                    placeholder: nil,
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ], completionHandler:
                        {
                            result in
                            //Kingfisher test
                                    switch result {
                                    case .success(let value):
                                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                                    case .failure(let error):
                                        print("Job failed: \(error.localizedDescription)")
                                    }
                        })
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let genre = genreIndex {
            cellDelegate?.mapSelectedMovieDetail(genre, indexPath.item)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}
