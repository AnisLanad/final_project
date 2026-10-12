import 'package:final_project/models%20/cart_item.dart';
import 'package:final_project/models%20/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class CartService {

  DatabaseReference _cartRef(){
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseDatabase.instance.ref('Carts').child(uid);
  }

  Future<void> addToCart(Product product) async{
    final itemRef = _cartRef().child(product.productId);
    final snapshot = await itemRef.get();

    if(snapshot.exists){
      final raw = snapshot.value as Map<dynamic,dynamic>;
      int quantity = 1;
      if(raw['quantity'] != null){
        final parsed = int.tryParse(raw['quantity'].toString());
        if(parsed != null){
          quantity = parsed;
        }
      }
      await itemRef.update({
        'quantity': quantity + 1,
      });
    } else {
      final item = CartItem(
        productId: product.productId,
        name: product.name,
        price: product.price,
        color: product.color,
        description: product.description,
        productImage: product.productImage,
        quantity: 1,
      );
      await itemRef.set(item.toMap());
    }
  }

  Future<void> removeFromCart(String productId) async{
    await _cartRef().child(productId).remove();
  }

  Future<void> clearCart() async{
    await _cartRef().remove();
  }

  Stream<List<CartItem>> watchCart(){
    return _cartRef().onValue.map((event){
      final raw = event.snapshot.value;
      if(raw == null ){
        return <CartItem>[];
      }
      final map = raw as Map<dynamic,dynamic>;
      final items = <CartItem>[];
      map.forEach((key,value){
          var item = CartItem.fromMap(key, value);    
          items.add(item);  
      });
      return items;
    });
  }

}
