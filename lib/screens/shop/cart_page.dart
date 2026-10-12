import 'package:final_project/models%20/cart_item.dart';
import 'package:final_project/screens/shop/order_form.dart';
import 'package:final_project/services/cart_service.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  final _service = CartService();

  int _total(List<CartItem> items){
    int total = 0;
    for(var item in items){
      int unit = 0;
      if(item.price != null){
        unit = item.price!;
      }
      total = total + (unit * item.quantity);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panier'),
      ),
      body: StreamBuilder<List<CartItem>>(
        stream: _service.watchCart(), 
        builder: (context,snapshot) {
          if(snapshot.hasError){
            return Center(child: Text('Erreur : ${snapshot.error}'),);
          }
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          final items = snapshot.data!;
          if(items.isEmpty){
            return Center(child: Text('panier vide'),);
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      leading: Image.network(
                        item.productImage,
                        width: 48,
                        height: 48,
                      ),
                      title: Text(item.name),
                      subtitle: Text('${item.price} DZD x ${item.quantity}'),
                      trailing: IconButton(
                        onPressed: (){
                          _service.removeFromCart(item.productId);
                        },
                        icon: Icon(Icons.delete),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => Divider(height: 1,),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Total : ${_total(items)} DZD', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),),
                    SizedBox(height: 12,),
                    ElevatedButton(
                      onPressed: (){
                        _service.clearCart();
                      },
                      child: Text('Vider le panier'),
                    ),
                    SizedBox(height: 12,),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderForm(items: items, totalPrice: _total(items))));
                      },
                      child: Text('Commander'),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}
