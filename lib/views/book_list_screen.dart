import 'package:flutter/material.dart';
import '../services/book_service.dart';
import '../models/book_model.dart';
import 'package:intl/intl.dart'; // Import for number formatting
import 'login_screen.dart'; // Import the LoginScreen

class BookListScreen extends StatelessWidget {
  final BookService _bookService = BookService();

  BookListScreen({super.key});

  // Function to format price as currency (e.g., Rp 1,000,000)
  String formatPrice(int price) {
    final formatter = NumberFormat('#,###');
    return 'Rp ${formatter.format(price)}';
  }

  // Fungsi untuk mengurangi stok setelah pembelian
  void _buyBook(BuildContext context, Book book) async {
    if (book.stock > 0) {
      bool? confirmBuy = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Konfirmasi Pembelian'),
            content:
                Text('Apakah Anda yakin ingin membeli buku "${book.title}"?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false); // Pembatalan
                },
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true); // Konfirmasi
                },
                child: const Text('Beli'),
              ),
            ],
          );
        },
      );

      if (confirmBuy == true) {
        // Kurangi stok buku sebanyak 1
        int newStock = book.stock - 1;
        Book updatedBook = Book(
          id: book.id,
          title: book.title,
          author: book.author,
          price: book.price,
          stock: newStock,
        );

        // Update data buku di Firestore
        await _bookService.updateBook(updatedBook);

        // Tampilkan pesan konfirmasi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pembelian buku "${book.title}" berhasil!')),
        );
      }
    } else {
      // Stok kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stok buku ini habis!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Buku'),
        actions: [
          // Logout button
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Navigasi kembali ke LoginScreen saat logout
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daftar Buku:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<Book>>(
              stream: _bookService.getBooks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text('Terjadi kesalahan: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Tidak ada buku.'));
                }

                var books = snapshot.data!;

                return Expanded(
                  child: ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      var book = books[index];
                      return ListTile(
                        title: Text(book.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(book.author),
                            const SizedBox(height: 4),
                            // Menampilkan stok buku
                            Text('Stok: ${book.stock}'),
                          ],
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Menampilkan harga
                            Text(formatPrice(book.price)),
                            // const SizedBox(height: 4),
                            // // Menampilkan informasi stok dalam trailing
                            // Text('Stok: ${book.stock}'),
                          ],
                        ),
                        // Menambahkan tombol beli
                        onTap: () => _buyBook(context, book),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
