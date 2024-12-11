class Book {
  String id;
  String title;
  String author;
  int price;
  int stock;  // Menambahkan properti stok

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.stock,  // Menambahkan parameter stok
  });

  // Membuat objek Book dari Map (misalnya data dari Firestore)
  factory Book.fromMap(Map<String, dynamic> data, String documentId) {
    return Book(
      id: documentId,  // Menyertakan ID yang dihasilkan Firestore
      title: data['title'] ?? 'Unknown Title',  // Default jika data tidak ada
      author: data['author'] ?? 'Unknown Author', // Default jika data tidak ada
      price: data['price'] ?? 0,  // Default jika data tidak ada
      stock: data['stock'] ?? 0,  // Default jika data tidak ada
    );
  }

  // Mengubah objek Book menjadi Map (untuk disimpan ke Firestore)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'price': price,
      'stock': stock,  // Menambahkan stok ke dalam Map
    };
  }

  // Method untuk menambah stok
  void addStock(int quantity) {
    if (quantity > 0) {
      stock += quantity;
    } else {
      throw ArgumentError("Quantity must be greater than zero.");
    }
  }

  // Method untuk mengurangi stok
  void reduceStock(int quantity) {
    if (quantity > 0 && stock >= quantity) {
      stock -= quantity;
    } else {
      throw ArgumentError("Insufficient stock or invalid quantity.");
    }
  }

  // Method untuk mendapatkan ketersediaan stok
  bool isAvailable() {
    return stock > 0;
  }
  
  // Override toString untuk melihat isi buku dengan mudah
  @override
  String toString() {
    return 'Book{id: $id, title: $title, author: $author, price: $price, stock: $stock}';
  }
}
