class Product {
    final String productId;
    final String name;
    final String description;
    final String color; 
    final int? price;
    final int? nbItems;
    final String productImage;

  Product({required this.productId, required this.name, required this.description, required this.color, required this.price, required this.nbItems, required this.productImage});

  factory Product.fromMap(String id, Map<dynamic,dynamic> map){
    return Product(
      productId: id,
      name: (map['name'] ?? '').toString(),
      description: (map['description'] ?? '').toString(),
      color: (map['color'] ?? '').toString(),
      productImage: (map['productImage'] ?? '').toString(),
      price: int.tryParse((map['price'] ?? 0).toString()) ?? 0,
      nbItems: int.tryParse((map['nbItems'] ?? 0).toString()) ?? 0,
    );
  }
  
  
  Map<String, dynamic> toMap(){
    return {
      'productId': productId,
      'name': name,
      'description': description,
      'color': color,
      'price': price, 
      'nbItems': nbItems,
      'productImage': productImage,
    };
  }
  

}
