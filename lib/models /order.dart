import 'package:final_project/models%20/cart_item.dart';

class Order {
    final String orderId;
    final String userId;
    final String fullName;
    final String phoneNumber;
    final String wilaya;
    final String address;
    final String comment;
    final int totalPrice;
    final List<CartItem> items;
    final String state;

  Order({required this.orderId, required this.userId, required this.fullName, required this.phoneNumber, required this.wilaya, required this.address, required this.comment, required this.totalPrice, required this.items, this.state = 'pending'});

  factory Order.fromMap(String id, Map<dynamic,dynamic> map){
    String userId = '';
    if(map['userId'] != null){
      userId = map['userId'].toString();
    }

    String fullName = '';
    if(map['fullName'] != null){
      fullName = map['fullName'].toString();
    }

    String phoneNumber = '';
    if(map['phoneNumber'] != null){
      phoneNumber = map['phoneNumber'].toString();
    }

    String wilaya = '';
    if(map['wilaya'] != null){
      wilaya = map['wilaya'].toString();
    }

    String address = '';
    if(map['address'] != null){
      address = map['address'].toString();
    }

    String comment = '';
    if(map['comment'] != null){
      comment = map['comment'].toString();
    }

    int totalPrice = 0;
    if(map['totalPrice'] != null){
      final parsed = int.tryParse(map['totalPrice'].toString());
      if(parsed != null){
        totalPrice = parsed;
      }
    }

    final items = <CartItem>[];
    if(map['items'] != null){
      final rawItems = map['items'] as Map<dynamic,dynamic>;
      rawItems.forEach((key,value){
        var item = CartItem.fromMap(key, value);
        items.add(item);
      });
    }

    String state = 'pending';
    if(map['state'] != null){
      state = map['state'].toString();
    }

    return Order(
      orderId: id,
      userId: userId,
      fullName: fullName,
      phoneNumber: phoneNumber,
      wilaya: wilaya,
      address: address,
      comment: comment,
      totalPrice: totalPrice,
      items: items,
      state: state,
    );
  }
  
  
  Map<String, dynamic> toMap(){
    final itemsMap = <String, dynamic>{};
    for(var item in items){
      itemsMap[item.productId] = item.toMap();
    }
    return {
      'orderId': orderId,
      'userId': userId,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'wilaya': wilaya,
      'address': address,
      'comment': comment,
      'totalPrice': totalPrice,
      'items': itemsMap,
      'state': state,
    };
  }
  

}
