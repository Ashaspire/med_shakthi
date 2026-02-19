class CartItem {
  final String id;
  final String name;
  final String? title;
  final String? brand;
  final String? size;
  final double price;
  final String? imagePath;
  int quantity;
  String? imageUrl;

  // ✅ NEW: Selection state
  bool isSelected;

  CartItem({
    required this.id,
    required this.name,
    this.title,
    this.brand,
    this.size,
    required this.price,
    this.imagePath,
    this.quantity = 1,
    this.imageUrl,
    this.isSelected = true, // default selected
  });

  String get displayTitle => title ?? name;
  String get displayImage => imagePath ?? imageUrl ?? '';
  double get totalPrice => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'brand': brand,
      'size': size,
      'price': price,
      'quantity': quantity,
      'imagePath': imagePath,
      'imageUrl': imageUrl,
      'isSelected': isSelected, // ✅ save selection locally
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      title: map['title'],
      brand: map['brand'],
      size: map['size'],
      price: (map['price'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 1,
      imagePath: map['imagePath'],
      imageUrl: map['imageUrl'],
      isSelected: map['isSelected'] ?? true,
    );
  }

  CartItem copyWith({
    int? quantity,
    bool? isSelected,
  }) {
    return CartItem(
      id: id,
      name: name,
      title: title,
      brand: brand,
      size: size,
      price: price,
      imagePath: imagePath,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
