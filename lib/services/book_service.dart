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

  // Fungsi untuk menambah stok buku
  Future<void> addStock(String bookId, int quantity) async {
    if (quantity <= 0) {
      print('Jumlah stok yang ditambahkan harus lebih dari 0');
      return;
    }
    try {
      // Mendapatkan referensi buku
      DocumentReference bookRef = _db.collection('books').doc(bookId);
      // Mendapatkan data buku yang ada
      DocumentSnapshot bookSnapshot = await bookRef.get();
      if (bookSnapshot.exists) {
        // Mendapatkan data stok saat ini
        int currentStock = bookSnapshot['stock'] ?? 0;
        // Menambah stok dengan quantity yang diberikan
        int newStock = currentStock + quantity;
        // Memperbarui stok buku di Firestore
        await bookRef.update({'stock': newStock});
        print('Stok buku dengan ID $bookId berhasil ditambah. Stok baru: $newStock');
      } else {
        print('Buku dengan ID $bookId tidak ditemukan.');
      }
    } catch (e) {
      print('Error adding stock: $e');
    }
  }

  // Fungsi untuk mengurangi stok buku
  Future<void> reduceStock(String bookId, int quantity) async {
    if (quantity <= 0) {
      print('Jumlah stok yang dikurangi harus lebih dari 0');
      return;
    }
    try {
      // Mendapatkan referensi buku
      DocumentReference bookRef = _db.collection('books').doc(bookId);
      // Mendapatkan data buku yang ada
      DocumentSnapshot bookSnapshot = await bookRef.get();
      if (bookSnapshot.exists) {
        // Mendapatkan data stok saat ini
        int currentStock = bookSnapshot['stock'] ?? 0;
        if (currentStock >= quantity) {
          // Mengurangi stok
          int newStock = currentStock - quantity;
          // Memperbarui stok buku di Firestore
          await bookRef.update({'stock': newStock});
          print('Stok buku dengan ID $bookId berhasil dikurangi. Stok baru: $newStock');
        } else {
          print('Stok tidak mencukupi untuk dikurangi.');
        }
      } else {
        print('Buku dengan ID $bookId tidak ditemukan.');
      }
    } catch (e) {
      print('Error reducing stock: $e');
    }
  }

  // Fungsi untuk memeriksa apakah buku tersedia
  Future<bool> isBookAvailable(String bookId) async {
    try {
      // Mendapatkan referensi buku
      DocumentReference bookRef = _db.collection('books').doc(bookId);
      // Mendapatkan data buku
      DocumentSnapshot bookSnapshot = await bookRef.get();
      if (bookSnapshot.exists) {
        int stock = bookSnapshot['stock'] ?? 0;
        return stock > 0;
      } else {
        print('Buku dengan ID $bookId tidak ditemukan.');
        return false;
      }
    } catch (e) {
      print('Error checking availability: $e');
      return false;
    }
  }
}
