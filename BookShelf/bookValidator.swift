import Foundation

enum ValidateError: Error, LocalizedError {
    case emptyTitle
    case emptyAuthor
    case invalidYear(Int)
    case invalidTag(String)
    
    var errorDescription: String? {
        switch self {
        case .emptyTitle: return "Title cannot be empty"
        case .emptyAuthor: return "Author cannot be empty"
        case .invalidYear(let y): return "Invalid year: \(y)"
        case .invalidTag(let tag): return "Invalid tag: \(tag)"
        }
    }
}

struct BookValidator {
    static let minYear = 1000
    static let maxYear = Calendar.current.component(.year, from: Date())
    
    static func validateTitle(_ title: String) throws -> String {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw ValidateError.emptyTitle
        }
        return title
    }
    
    static func validateAuthor(_ author: String) throws -> String {
        guard !author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw ValidateError.emptyAuthor
        }
        return author
    }
    
    static func validateYear(_ year: Int?) throws -> Int? {
        guard let year = year else {
            return nil
        }
        guard year >= minYear && year <= maxYear else {
            throw ValidateError.invalidYear(year)
        }
        
        return year
    }
}
