import Foundation

enum SearchQuery {
    case title(String)
    case author(String)
    case genre(Genre)
    case tag(String)
    case year(Int)
}

enum BookShelfError: Error {
    case duplicateID
    case bookNotFound
    case invalidInput(String)
}

protocol BookShelfProtocol {
    func add(_ book: Book) throws
    func delete(byID: String) throws
    func list() -> [Book]
    func search(_ query: SearchQuery) throws -> [Book]
}

class BookShelf: BookShelfProtocol {
    private var books: [String: Book] = [:]
    
    func add(_ book: Book) throws {
        guard books[book.id] == nil else {
            throw BookShelfError.duplicateID
        }
        
        guard !book.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, !book.author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw BookShelfError.invalidInput("Title or Author cannot be empty")
        }
        
        guard book.publicationYear ?? 0 >= 0 else {
            throw BookShelfError.invalidInput("Publication year must be a non-negative integer")
        }
        
        guard Genre.allCases.contains(book.genre) else {
            let genreNames = Genre.allCases.map { $0.rawValue }.joined(separator: ", ")
            throw BookShelfError.invalidInput("Genre must be one of following: \(genreNames)")
        }
        
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
            guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                throw BookShelfError.invalidInput("Title cannot be empty")
            }
            return allBooks.filter { $0.title.lowercased().contains(title.lowercased()) }
            
        case .author(let author):
            guard !author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                throw BookShelfError.invalidInput("Author cannot be empty")
            }
            return allBooks.filter { $0.author.lowercased().contains(author.lowercased()) }
            
        case .genre(let genre):
            return allBooks.filter { $0.genre == genre }
            
        case .tag(let tag):
            return allBooks.filter { $0.tags.contains(tag) }
            
        case .year(let year):
            guard year >= 0 else {
                throw BookShelfError.invalidInput("Publication year must be a non-negative integer")
            }
            return allBooks.filter { $0.publicationYear == year }
        }
    }
}
