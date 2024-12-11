import 'package:flutter/material.dart';
import 'login_screen.dart'; // Pastikan LoginScreen sudah diimport
import '../services/book_service.dart';
import '../models/book_model.dart';

class BookListScreen extends StatelessWidget {
  final BookService _bookService = BookService();

  BookListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Buku'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app), // Ikon logout
            onPressed: () {
              // Navigasi ke halaman login
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
            const Text('Daftar Buku:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            StreamBuilder<List<Book>>(
              stream: _bookService.getBooks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
                        subtitle: Text(book.author),
                        trailing: Text(_bookService.formatRupiah(
                            book.price)), // Format harga dengan rupiah
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
