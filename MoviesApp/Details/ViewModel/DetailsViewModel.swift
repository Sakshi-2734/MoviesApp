//
//  DetailsViewModel.swift
//  MoviesApp
//
//  Created by Sakshi Sharma on 2023-07-29.
//

import Foundation

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
    
    /**
     Download image data from URL
     */
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
