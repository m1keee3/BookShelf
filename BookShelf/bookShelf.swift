import Foundation

enum SearchQuery {
    case title(String)
    case author(String)
    case genre(Genre)
    case tag(String)
    case year(Int)
}

enum BookShelfError: Error, LocalizedError {
    case bookNotFound
    
    var errorDescription: String? {
        switch self {
        case .bookNotFound: return "Book not found"
        }
    }
}

protocol BookShelfProtocol {
    func add(title: String, author: String, year: Int?, genre: Genre, tags: [String]) throws
    func delete(byID: String) throws
    func list() -> [Book]
    func search(_ query: SearchQuery) throws -> [Book]
}

class BookShelf: BookShelfProtocol {
    private var books: [String: Book] = [:]
    
    func add(title: String, author: String, year: Int?, genre: Genre, tags: [String]) throws {
        
        let title = try BookValidator.validateTitle(title)
        let author = try BookValidator.validateAuthor(author)
        let year = try BookValidator.validateYear(year)
        
        let book = Book(id: UUID().uuidString, title: title, author: author, year: year, genre: genre, tags: tags)
        
        books[book.id] = book
    }
    
    func delete(byID id: String) throws {
        guard books[id] != nil else {
            throw BookShelfError.bookNotFound
        }
        
        books.removeValue(forKey: id)
    }
    
    func list() -> [Book] {
        return Array(books.values)
    }
    
    func search(_ query: SearchQuery) throws -> [Book] {
        let allBooks = Array(books.values)
        
        switch query {
        case .title(let title):
            let validTitle = try BookValidator.validateTitle(title)
            return allBooks.filter { $0.title.lowercased().contains(validTitle.lowercased()) }
            
        case .author(let author):
            let validAuthor = try BookValidator.validateAuthor(author)
            return allBooks.filter { $0.author.lowercased().contains(validAuthor.lowercased()) }
            
        case .year(let year):
            let validYear = try BookValidator.validateYear(year)
            if validYear == nil { return [] }
            return allBooks.filter { $0.year == validYear }
        case .genre(let genre):
            return allBooks.filter { $0.genre == genre }
            
        case .tag(let tag):
            return allBooks.filter { $0.tags.contains(tag) }
        }
    }
}
