//
//  DetailsViewModel.swift
//  MoviesApp
//
//  Created by Sakshi Sharma on 2023-07-26.
//

import Foundation


import UIKit

class DetailsViewModel: NSObject {

    func mapReleaseYear(_ releaseString: String) -> Int {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate]
        let date = dateFormatter.date(from:releaseString)
        
        let calendar = Calendar.current
        let releaseYear = calendar.component(.year, from: date ?? Date())
        return releaseYear
    }
    
    func mapDetailArray(_ names: [String]) -> String? {
        var nameString = names.first
        for index in 1..<names.count {
            nameString?.append(", \(names[index])")
        }
        return nameString
    }
    
    func mapMovieRating(_ rating: Double?) -> CGFloat {
        if let movieRatig = rating {
            let rate = movieRatig/2
            return CGFloat(rate)
        }
        return 0
    }
}
