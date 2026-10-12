class CartItem {
    final String productId;
    final String name;
    final int? price;
    final String color;
    final String description;
    final String productImage;
    final int quantity;

  CartItem({required this.productId, required this.name, required this.price, required this.color, required this.description, required this.productImage, required this.quantity});

  factory CartItem.fromMap(String id, Map<dynamic,dynamic> map){
    String name = '';
    if(map['name'] != null){
      name = map['name'].toString();
    }

    String color = '';
    if(map['color'] != null){
      color = map['color'].toString();
    }

    String description = '';
    if(map['description'] != null){
      description = map['description'].toString();
    }

    String productImage = '';
    if(map['productImage'] != null){
      productImage = map['productImage'].toString();
    }

    int price = 0;
    if(map['price'] != null){
      final parsedPrice = int.tryParse(map['price'].toString());
      if(parsedPrice != null){
        price = parsedPrice;
      }
    }

    int quantity = 1;
    if(map['quantity'] != null){
      final parsedQuantity = int.tryParse(map['quantity'].toString());
      if(parsedQuantity != null){
        quantity = parsedQuantity;
      }
    }

    return CartItem(
      productId: id,
      name: name,
      description: description,
      color: color,
      productImage: productImage,
      price: price,
      quantity: quantity,
    );
  }
  
  
  Map<String, dynamic> toMap(){
    return {
      'productId': productId,
      'name': name,
      'description': description,
      'color': color,
      'price': price, 
      'productImage': productImage,
      'quantity': quantity,
    };
  }
  

}
