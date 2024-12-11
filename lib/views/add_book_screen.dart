import 'package:flutter/material.dart';
import '../services/book_service.dart';
import '../models/book_model.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  AddBookScreenState createState() => AddBookScreenState();
}

class AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController(); // Controller untuk stok
  final BookService _bookService = BookService();

  Future<void> _uploadBook() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Ambil stok dari TextField dan konversi ke integer
        int stock = int.tryParse(_stockController.text) ?? 0;

        // Create book object
        Book book = Book(
          id: '', // Firestore will generate the ID
          title: _titleController.text,
          author: _authorController.text,
          price: int.parse(_priceController.text),
          stock: stock, // Menambahkan stok ke dalam book
        );

        await _bookService.addBook(book);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Buku berhasil ditambahkan')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Buku Baru'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul Buku'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul buku tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Pengarang'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pengarang tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stockController, // Menambahkan TextFormField untuk stok
                decoration: const InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Stok harus berupa angka';
                  }
                  if (int.tryParse(value)! < 0) {
                    return 'Stok tidak boleh negatif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _uploadBook,
                child: const Text('Tambah Buku'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
