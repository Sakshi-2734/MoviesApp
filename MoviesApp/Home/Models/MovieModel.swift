import UIKit

//searchBaseURL
struct BaseUrl: Codable {
    let movieBaseUrl: String
    let searchBaseUrl: String
    let movieAuthorizationKey: String
}

struct MoviesModel: Codable {
    let movies: [MovieDetailModel]?
}

struct MovieDetailModel: Codable {
    let title: String?
    let poster: String?
    let backdrop: String?
    let overview: String?
    let genres: [String]?
    let length: String?
    let releasedOn: String?
    let cast: [String]?
    let imdbRating: Double?
    
    //Director - As per Api response director can be String or [String].
    let director: [String]?
    
    private enum CodingKeys: String, CodingKey {
        case title = "title"
        case poster = "poster"
        case backdrop = "backdrop"
        case overview = "overview"
        case genres = "genres"
        case length = "length"
        case director = "director"
        case releasedOn = "releasedOn"
        case cast = "cast"
        case imdbRating = "imdbRating"
    }
        
    init(title: String? = nil,
         poster: String? = nil,
         backdrop: String? = nil,
         overview: String? = nil,
         genres: [String]? = [],
         length: String? = nil,
         director: [String]? = [],
         releasedOn: String? = nil,
         cast: [String]? = [],
         imdbRating: Double? = 0.0) {
        self.title = title
        self.poster = poster
        self.backdrop = backdrop
        self.overview = overview
        self.genres = genres
        self.length = length
        self.director = director
        self.releasedOn = releasedOn
        self.cast = cast
        self.imdbRating = imdbRating
        }
    
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            title = try container.decode(String.self, forKey: .title)
            poster = try container.decode(String.self, forKey: .poster)
            backdrop = try container.decode(String.self, forKey: .backdrop)
            overview = try container.decode(String.self, forKey: .overview)
            genres = try container.decode([String].self, forKey: .genres)
            length = try container.decode(String.self, forKey: .length)
            releasedOn = try container.decode(String.self, forKey: .releasedOn)
            cast = try container.decode([String].self, forKey: .cast)
            imdbRating = try container.decode(Double.self, forKey: .imdbRating)
            do {
                director = try container.decode([String].self, forKey: .director)
            } catch DecodingError.typeMismatch {
                let value = try container.decode(String.self, forKey: .director)
                director = [value]
            }
        }
}
