enum Genre: String, CaseIterable, Codable {
    case fantasy, horror, romance, thriller, biography
}

struct Book: Identifiable, Equatable, Codable {
    let id: String
    var title: String
    var author: String
    var year: Int?
    var genre: Genre
    var tags: [String]
}
