import 'package:final_project/models%20/product.dart';
import 'package:final_project/screens/shop/cart_page.dart';
import 'package:final_project/screens/shop/product_page.dart';
import 'package:final_project/screens/shop/track_orders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:final_project/services/product_service.dart';

class ShopHome extends StatelessWidget {
  ShopHome({super.key});
  
  final _service = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shope space'),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>TrackOrders()));
          }, icon: Icon(Icons.local_shipping)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CartPage()));
          }, icon: Icon(Icons.shopping_cart)),
          IconButton(onPressed: (){FirebaseAuth.instance.signOut();}, icon: Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder<List<Product>>(
        stream: _service.retrieveProducts(), 
        builder: (context,snapshot) {
          if(snapshot.hasError){
            return Center(child: Text('Erreur : ${snapshot.error}'),);
          }
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          final products = snapshot.data!;
          if(products.isEmpty){
            return Center(child: Text('aucun produit dans la base de donner'),);
          }
          return GridView.builder(
            padding: EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.70
            ), 
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductPage(product: product)));
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        product.productImage
                      ),
                      Padding(padding: EdgeInsets.all(12),
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name, style: TextStyle(fontSize: 16),),
                          Text('${product.price}DZD',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                        ],
                        ),
                      )
                      
                    ],
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }
}