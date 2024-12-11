class Book {
  final String id;
  final String title;
  final String author;
  final int price;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
  });

  factory Book.fromFirestore(Map<String, dynamic> data, String id) {
    return Book(
      id: id,
      title: data['title'],
      author: data['author'],
      price: data['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'price': price,
    };
  }
}
