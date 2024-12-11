import 'package:flutter/material.dart';
import 'package:perpustakaan_flutter/views/login_screen.dart';
import 'add_book_screen.dart'; // Halaman untuk menambahkan buku
import 'edit_book_screen.dart'; // Halaman untuk mengedit buku
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
              // Navigasi kembali ke LoginScreen
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
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(book.author),
                            const SizedBox(height: 4),
                            // Menampilkan stok buku
                            Text('Stok: ${book.stock}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Tombol Edit
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Navigasi ke halaman EditBookScreen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditBookScreen(book: book),
                                  ),
                                );
                              },
                            ),
                            // Tombol Hapus
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                // Konfirmasi sebelum menghapus
                                bool? confirmDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Hapus Buku?'),
                                      content: const Text(
                                          'Apakah Anda yakin ingin menghapus buku ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: const Text('Hapus'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirmDelete == true) {
                                  // Hapus buku jika dikonfirmasi
                                  await _bookService.deleteBook(book.id);
                                }
                              },
                            ),
                          ],
                        ),
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
        child: const Icon(Icons.add),
        tooltip: 'Tambah Buku',
      ),
    );
  }
}
