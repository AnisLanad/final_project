import 'package:final_project/models%20/product.dart';
import 'package:final_project/services/cart_service.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  final Product product;
  ProductPage({super.key, required this.product});

  final _cartService = CartService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name),),
      body: ListView(
        children: [
          Image.network(
            product.productImage, 
            height: 260, 
            width: double.infinity,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,style: TextStyle(fontSize: 21),),
                SizedBox(height: 12,),
                Text('${product.price} DZD',style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                SizedBox(height: 12,),
                Text('Stock : ${product.nbItems} disponible en stock', style: TextStyle(fontSize: 21),),
                SizedBox(height: 12,),
                Text(product.description, style: TextStyle(fontSize: 18),),
                SizedBox(height: 12,),
                ElevatedButton(
                  onPressed: (){
                    _cartService.addToCart(product);
                  },
                  child: Text('Ajouter au panier'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}