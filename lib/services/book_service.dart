import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';
import 'package:intl/intl.dart';

class BookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String formatRupiah(int amount) {
    final numberFormat = NumberFormat(
        '#,##0', 'id_ID'); // Menggunakan locale 'id_ID' untuk Indonesia
    return 'Rp ${numberFormat.format(amount)}';
  }

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
