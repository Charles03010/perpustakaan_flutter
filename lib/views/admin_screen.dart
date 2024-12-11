import 'package:flutter/material.dart';
import 'package:perpustakaan_flutter/views/login_screen.dart';
import 'add_book_screen.dart';  // Halaman untuk menambahkan buku
import '../services/book_service.dart';
import '../models/book_model.dart';

class AdminScreen extends StatelessWidget {
  final BookService _bookService = BookService();

 AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Buku - Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Logout atau kembali ke halaman login
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
            const Text('Daftar Buku:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                        trailing: Text(_bookService.formatRupiah(book.price)), // Format harga dengan rupiah
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke AddBookScreen untuk menambah buku
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBookScreen()),
          );
        },
        tooltip: 'Tambah Buku', // Tooltip untuk FAB
        child: const Icon(Icons.add),
      ),
    );
  }
}
