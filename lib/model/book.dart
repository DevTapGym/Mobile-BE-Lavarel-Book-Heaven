class Book {
  final int id;
  final String title;
  final String? description;
  final String thumbnail;
  final String author;
  final double price;
  final int quantity;
  final int sold;
  final double saleOff;
  final bool isActive;

  Book({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.author,
    required this.price,
    required this.quantity,
    required this.sold,
    required this.saleOff,
    required this.isActive,
    this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      author: json['author'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      quantity: json['quantity'] ?? 0,
      sold: json['sold'] ?? 0,
      saleOff: double.tryParse(json['sale_off'].toString()) ?? 0.0,
      isActive: json['is_active'] == 1,
    );
  }
}
