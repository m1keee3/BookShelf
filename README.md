# BookShelf

## Команды и сценарии
Главное меню:
```text
1. Add book     - Добавить новую книгу
2. Delete book  - Удалить книгу по ID
3. Book list    - Показать все книги
4. Search       - Поиск книг по критериям
0. Exit         - Выход из программы
```

### Примеры использования:
Сценарий 1: Добавление книги
```text
Main menu
1. Add book
2. Delete book
3. Book list
4. Search
0. Exit

Input command: 1

Adding book

Book title: The Hobbit
Author: J.R.R. Tolkien
Year (optional): 1937
Choose genre: 
1. fantasy
2. horror
3. romance
4. thriller
5. biography
Enter the number of the genre: 1
Enter tags separated by comma: adventure, magic, dragons
Book added successfully
Press Enter to continue...
```
Сценарий 2: Просмотр всех книг
```text
Input command: 3

Books list

ID: 550E8400-E29B-41D4-A716-446655440000
Title: The Hobbit
Author: J.R.R. Tolkien
Year: 1937
Genre: fantasy
Tags: adventure, magic, dragons

Press Enter to continue...
```
Сценарий 3: Поиск книг по автору
```text
Input command: 4

Search books

Available filters:
1. By title
2. By author
3. By genre
4. By tags
5. By year
Input filter number: 2
Enter author: Tolkien

Search results:
ID: 550E8400-E29B-41D4-A716-446655440000
Title: The Hobbit
Author: J.R.R. Tolkien
Year: 1937
Genre: fantasy
Tags: adventure, magic, dragons

Press Enter to continue...
```
Сценарий 4: Удаление книги
```text
Input command: 2

Deleting book

The Hobbit - ID: 550E8400-E29B-41D4-A716-446655440000
Input book ID: 550E8400-E29B-41D4-A716-446655440000
Book deleted successfully
Press Enter to continue...
```
Сценарий 5: Поиск по году
```text
Input command: 4

Search books

Available filters:
1. By title
2. By author
3. By genre
4. By tags
5. By year
Input filter number: 5
Enter year: 1937

Search results:
ID: 550E8400-E29B-41D4-A716-446655440000
Title: The Hobbit
Author: J.R.R. Tolkien
Year: 1937
Genre: fantasy
Tags: adventure, magic, dragons

Press Enter to continue...
```
