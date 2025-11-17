import Foundation

enum Secrets {
    static var tmdbAPIKey: String {
        Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? ""
    }
}
