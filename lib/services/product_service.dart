import 'package:final_project/models%20/product.dart';
import 'package:firebase_database/firebase_database.dart';

class ProductService {

  final DatabaseReference _ref = FirebaseDatabase.instance.ref('Products');

  Future<void> addProduct(Product product) async{
    final newRef = _ref.push();

    final id = newRef.key!;
    final data = product.toMap();

    data['productId'] = id;

    newRef.set(data);

  }

  Stream<List<Product>> retrieveProducts(){
    return _ref.onValue.map((event){
      final raw = event.snapshot.value;
      if(raw == null ){
        return <Product>[];
      }
      final map = raw as Map<dynamic,dynamic>;
      final products = <Product>[];
      map.forEach((key,value){
          var product = Product.fromMap(key, value);    
          products.add(product);  
      });
      return products;


    });
  }


   Future<void> updateProduct(Product product) async{
      await _ref.child(product.productId).update(product.toMap());
  }

  Future<void> deleteProduct(String productId) async{
    await _ref.child(productId).remove();
  }


  
}
