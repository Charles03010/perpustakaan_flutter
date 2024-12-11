import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';

class BookService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fungsi untuk mengambil daftar buku dari Firestore
  Stream<List<Book>> getBooks() {
    return _db.collection('books').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Book.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  // Fungsi untuk menambahkan buku ke Firestore
  Future<void> addBook(Book book) async {
    try {
      // Tambahkan buku ke koleksi dan dapatkan ID yang dihasilkan Firestore
      DocumentReference docRef = await _db.collection('books').add(book.toMap());
      // Update ID buku yang baru ditambahkan
      book.id = docRef.id;
      print('Buku ditambahkan dengan ID: ${docRef.id}');
    } catch (e) {
      print('Error adding book: $e');
    }
  }

  // Fungsi untuk menghapus buku
  Future<void> deleteBook(String bookId) async {
    try {
      await _db.collection('books').doc(bookId).delete();
    } catch (e) {
      print('Error deleting book: $e');
    }
  }

  // Fungsi untuk memperbarui buku
  Future<void> updateBook(Book book) async {
    try {
      await _db.collection('books').doc(book.id).update(book.toMap());
    } catch (e) {
      print('Error updating book: $e');
    }
  }
}
