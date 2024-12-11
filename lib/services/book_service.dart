import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';


class BookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all books
  Stream<List<Book>> getBooks() {
    return _firestore.collection('books').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Book.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  // Add a new book
  Future<void> addBook(Book book) async {
    await _firestore.collection('books').add(book.toJson());
  }
}
