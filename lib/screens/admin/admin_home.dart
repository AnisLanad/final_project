import 'package:final_project/models%20/product.dart';
import 'package:final_project/screens/admin/admin_orders.dart';
import 'package:final_project/screens/admin/product_form.dart';
import 'package:final_project/services/product_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminHome extends StatelessWidget {
  AdminHome({super.key});

  Future<void> _confirmDelete(BuildContext context, Product product) async {
      final confirmed = await showDialog<bool>(
        context: context, 
        builder: (dialogContext) => AlertDialog(
            title: Text('Supprimer produit ?'),
            content: Text(product.name),
            actions: [
              TextButton(onPressed: (){Navigator.pop(dialogContext,false);}, child: Text('Annuler')),
              TextButton(onPressed: (){Navigator.pop(dialogContext,true);}, child: Text('Supprimer')),

            ],
        )
      );
      if(confirmed == true){
        await ProductService().deleteProduct(product.productId);
      }
  }

  final _service = ProductService();
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Espace admin'),
         actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminOrders()));
            },
            icon: Icon(Icons.receipt_long),
          ),
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
          return ListView.separated(
            padding: EdgeInsets.only(bottom: 80),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: Image.network(
                  product.productImage,
                  width: 48,
                  height: 48,
                ),
                title: Text(product.name),
                trailing: Text('${product.price} DA'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductForm(existing: product,)));
                },
                onLongPress: () {
                  _confirmDelete(context, product);
                },
              );
            }, separatorBuilder: (BuildContext context, int index) => Divider(height: 1,),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProductForm()));
      },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}