class Book {
  String id;
  String title;
  String author;
  int price;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
  });

  // Membuat objek Book dari Map (misalnya data dari Firestore)
  factory Book.fromMap(Map<String, dynamic> data, String documentId) {
    return Book(
      id: documentId, // Menyertakan ID yang dihasilkan Firestore
      title: data['title'],
      author: data['author'],
      price: data['price'],
    );
  }

  // Mengubah objek Book menjadi Map (untuk disimpan ke Firestore)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'price': price,
    };
  }
}
