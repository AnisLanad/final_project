import 'package:final_project/models%20/order.dart';
import 'package:firebase_database/firebase_database.dart';

class OrderService {

  final DatabaseReference _ref = FirebaseDatabase.instance.ref('Orders');

  Future<void> PlaceOrder(Order order) async{
    final newRef = _ref.push();

    final id = newRef.key!;
    final data = order.toMap();

    data['orderId'] = id;

    await newRef.set(data);

  }

  Stream<List<Order>> watchOrders(){
    return _ref.onValue.map((event){
      final raw = event.snapshot.value;
      if(raw == null){
        return <Order>[];
      }
      final map = raw as Map<dynamic,dynamic>;
      final orders = <Order>[];
      map.forEach((key,value){
        var order = Order.fromMap(key, value);
        orders.add(order);
      });
      return orders;
    });
  }

  Stream<List<Order>> retrieveOrders(String userId){
    return _ref.onValue.map((event){
      final raw = event.snapshot.value;
      if(raw == null){
        return <Order>[];
      }
      final map = raw as Map<dynamic,dynamic>;
      final orders = <Order>[];
      map.forEach((key,value){
        var order = Order.fromMap(key, value);
        if(order.userId == userId){
          orders.add(order);
        }
      });
      return orders;
    });
  }

  Future<void> updateState(String orderId, String state) async{
    await _ref.child(orderId).update({'state': state});
  }

}
