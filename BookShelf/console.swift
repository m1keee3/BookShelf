import Foundation

class Console {
    private let bookShelf: BookShelfProtocol
    
    init(bookShelf: BookShelfProtocol) {
        self.bookShelf = bookShelf
    }
    
    func start() {
        
        while true {
            printCmds()
            print("\nInput command: ", terminator: "")
            
            guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                continue
            }
            
            switch input {
            case "1":
                addBook()
            case "2":
                deleteBook()
            case "3":
                listBooks()
            case "4":
                searchBooks()
            case "0":
                print("Goodbye.")
                return
            default:
                print("Incorect input")
            }
        }
    }
    
    private func printCmds() {
        print("Main menu")
        print()
        
        print("""
            1. Add book
            2. Delete book
            3. Book list
            4. Search
            0. Exit
            """)
    }
    
    private func addBook() {
        print("Adding book")
        print()
        
        print("Book title: ", terminator: "")
        let title = readLine() ?? ""
        
        print("Author: ", terminator: "")
        let author = readLine() ?? ""
        
        print("Year (optional): ", terminator: "")
        let yearInput = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let year = Int(yearInput)
        
        print("Choose genre: ")
        let genres = Genre.allCases
        for (index, genre) in genres.enumerated() {
            print("\(index + 1). \(genre.rawValue)")
        }
        print("Enter the number of the genre: ", terminator: "")
        guard let genreChoice = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines),
                !genreChoice.isEmpty,
              let genreIndex = Int(genreChoice),
                genreIndex > 0, genreIndex <= genres.count else {
            print("Incorrect input")
            InputEnter()
            return
        }
        let genre = genres[genreIndex - 1]
        
        print("Enter tags separated by comma: ", terminator: "")
        let tagsInput = readLine() ?? ""
        let tags = tagsInput.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines)}
            .filter {!$0.isEmpty }
        
        do {
            try bookShelf.add(title: title, author: author, year: year, genre: genre, tags: tags)
            print("Book added successfully")
        } catch {
            print("Failed to add book: \(error.localizedDescription)")
        }
        
        InputEnter()
    }
    
    private func deleteBook() {
        print("Deleting book")
        print()
        
        let books = bookShelf.list()
        guard !books.isEmpty else {
            print("Book shelf is empty")
            InputEnter()
            return
        }
        
        for book in books {
            print("\(book.title) - ID: \(book.id)")
        }
        
        print("Input book ID: ", terminator: "")
        guard let id = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), !id.isEmpty else {
            print("ID cannot be empty")
            InputEnter()
            return
        }
        
        do {
            try bookShelf.delete(byID: id)
            print("Book deleted successfully")
        } catch BookShelfError.bookNotFound {
            print("Book with ID: \(id) not found")
        } catch {
            print("Failed to delete book: \(error.localizedDescription)")
        }
        
        InputEnter()
    }
    
    private func listBooks() {
        print("Books list")
        print()
        
        let books = bookShelf.list()
        
        if books.isEmpty {
            print("Book shelf is empty")
            InputEnter()
            return
        }
        
        for book in books {
            print("ID: \(book.id)")
            print("Title: \(book.title)")
            print("Author: \(book.author)")
            print("Year: \(book.year?.description ?? "-")")
            print("Genre: \(book.genre.rawValue)")
            print("Tags: \(book.tags.isEmpty ? "-" : book.tags.joined(separator: ", "))")
            print()
        }
    
        InputEnter()
    }
    
    private func searchBooks() {
        print("Search books")
        print()
        
        print("Available filters:")
        print("1. By title")
        print("2. By author")
        print("3. By genre")
        print("4. By tags")
        print("5. By year")
        
        print("Input filter number: ", terminator: "")
        guard let choice = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            print("Number cannot be empty")
            InputEnter()
            return
        }
        
        switch choice {
        case "1":
            print("Enter title: ", terminator: "")
            
            do {
                let results = try bookShelf.search(.title(readLine() ?? ""))
                printSearchResult(results)
            } catch {
                print("Failed to search by title: \(error.localizedDescription)")
            }
            InputEnter()
            
        case "2":
            print("Enter author: ", terminator: "")
            
            do {
                let results = try bookShelf.search(.author(readLine() ?? ""))
                printSearchResult(results)
            } catch {
                print("Failed to search by author: \(error.localizedDescription)")
            }
            InputEnter()
            
        case "3":
            print("Choose genre:")
            let genres = Genre.allCases
            for (index, genre) in genres.enumerated() {
                print("\(index + 1). \(genre.rawValue)")
            }
            print("Enter the number of the genre: ", terminator: "")
            guard let genreChoice = readLine(), let index = Int(genreChoice),
                    index > 0, index <= genres.count else {
                print("Incorrect input")
                InputEnter()
                return
            }
            do {
                let results = try bookShelf.search(.genre(genres[index - 1]))
                printSearchResult(results)
            } catch {
                print("Failed to search by genre: \(error.localizedDescription)")
            }
            InputEnter()
            
        case "4":
            print("Enter tag: ", terminator: "")
            
            do {
                let results = try bookShelf.search(.tag(readLine() ?? ""))
                printSearchResult(results)
            } catch {
                print("Failed to search by tag: \(error.localizedDescription)")
            }
            InputEnter()
            
        case "5":
            print("Enter year: ", terminator: "")
            guard let yearInput = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                print("Year cannot be empty")
                InputEnter()
                return
            }
            guard let year = Int(yearInput) else {
                print("Year must be integer")
                InputEnter()
                return
            }
            
            do {
                let results  = try bookShelf.search(.year(year))
                printSearchResult(results)
            } catch {
                print("Failed to search by year: \(error.localizedDescription)")
            }
            
            InputEnter()
            
        default:
            print("Incorrect input")
            InputEnter()
        }
    }
    
    private func printSearchResult(_ books: [Book]) {
        guard !books.isEmpty else {
            print("Nothing found")
            InputEnter()
            return
        }
        
        print("Seqrch results:")
        
        for book in books {
            print("ID: \(book.id)")
            print("Title: \(book.title)")
            print("Author: \(book.author)")
            print("Year: \(book.year?.description ?? "-")")
            print("Genre: \(book.genre.rawValue)")
            print("Tags: \(book.tags.isEmpty ? "-" : book.tags.joined(separator: ", "))")
            print()
        }
    }
    
    private func InputEnter() {
        print("Press Enter to continue...", terminator: "")
        _ = readLine()
    }
}
