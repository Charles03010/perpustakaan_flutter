import 'package:flutter/material.dart';
import '../services/book_service.dart';
import '../models/book_model.dart';

class EditBookScreen extends StatefulWidget {
  final Book book;

  const EditBookScreen({super.key, required this.book});

  @override
  EditBookScreenState createState() => EditBookScreenState();
}

class EditBookScreenState extends State<EditBookScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController =
      TextEditingController(); // Controller untuk stok

  final BookService _bookService = BookService();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.book.title;
    _authorController.text = widget.book.author;
    _priceController.text = widget.book.price.toString();
    _stockController.text =
        widget.book.stock.toString(); // Menginisialisasi stok
  }

  void _updateBook() async {
    final updatedBook = Book(
      id: widget.book.id,
      title: _titleController.text,
      author: _authorController.text,
      price: int.parse(_priceController.text),
      stock: int.parse(_stockController.text), // Menambahkan stok ke buku
    );

    await _bookService.updateBook(updatedBook);

    // Kembali ke AdminScreen setelah update
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Buku'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Judul Buku'),
            ),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Penulis Buku'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Harga Buku'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _stockController,
              decoration: const InputDecoration(labelText: 'Stok Buku'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateBook,
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
