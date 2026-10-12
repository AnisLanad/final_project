import 'package:final_project/models%20/cart_item.dart';
import 'package:final_project/models%20/order.dart';
import 'package:final_project/services/cart_service.dart';
import 'package:final_project/services/order_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderForm extends StatefulWidget {
  final List<CartItem> items;
  final int totalPrice;
  const OrderForm({super.key, required this.items, required this.totalPrice});

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  final _service = OrderService();
  final _cartService = CartService();
  final _fullNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _wilayaCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _commentCtrl = TextEditingController();

  bool _loading = false;
  String _error = '';

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _phoneCtrl.dispose();
    _wilayaCtrl.dispose();
    _addressCtrl.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async{
    setState(() {
      _loading = true;
    });

    try{
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final order = Order(
        orderId: '',
        userId: uid,
        fullName: _fullNameCtrl.text.trim(),
        phoneNumber: _phoneCtrl.text.trim(),
        wilaya: _wilayaCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        comment: _commentCtrl.text.trim(),
        totalPrice: widget.totalPrice,
        items: widget.items,
      );

      await _service.PlaceOrder(order);
      await _cartService.clearCart();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('commande envoyer'))
      );
      Navigator.pop(context);

    }catch(e){
      setState(() {
        _error = e.toString();
      });
    }
    setState(() {
      _loading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commander'),
      ),
      body: SafeArea(child: ListView(
        padding: EdgeInsets.all(24),
        children: [
          Text('Total : ${widget.totalPrice} DZD', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),),
          SizedBox(height: 16,),
          TextField(
            controller: _fullNameCtrl,
            decoration: InputDecoration(
              labelText: 'Nom complet',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)
              )

            ),
          ),
          SizedBox(height: 16,),
          TextField(
            controller: _phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Telephone',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)
              )

            ),
          ),
          SizedBox(height: 16,),
          TextField(
            controller: _wilayaCtrl,
            decoration: InputDecoration(
              labelText: 'Wilaya',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)
              )

            ),
          ),
          SizedBox(height: 16,),
          TextField(
            controller: _addressCtrl,
            decoration: InputDecoration(
              labelText: 'Adresse',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)
              )

            ),
          ),
          SizedBox(height: 16,),
          TextField(
            controller: _commentCtrl,
            decoration: InputDecoration(
              labelText: 'Commentaire',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)
              )

            ),
          ),
          const SizedBox(height: 24),

          if(_error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(_error, style: TextStyle(color: Colors.red),),
            ),

          ElevatedButton(
            onPressed: _loading ? null : _submit,
            child: Text(_loading ? '...' : 'Commander'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
          )


        ],
      )),
    );
  }
}
