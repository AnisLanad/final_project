import 'package:final_project/screens/admin/admin_home.dart';
import 'package:final_project/screens/login_page.dart';
import 'package:final_project/screens/shop/shop_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), 
      builder: (context,snapshot) {

        if(snapshot.connectionState == ConnectionState.waiting){
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(),),
          );

        }
        final user = snapshot.data;

        if (user == null){
          return LoginPage();
        }

        return RoleGate(uid : user.uid);



      }
    );
  }
}



class RoleGate extends StatelessWidget {
  final String uid;
  const RoleGate({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseDatabase.instance.ref('Users/$uid/admin');
    return FutureBuilder<DataSnapshot>(
      future: ref.get(), 
      builder: (context, snapshot){
        if(!snapshot.hasData){
            return Scaffold(
              body: Center(child: CircularProgressIndicator(),),
            );
        }

        final isAdmin = snapshot.data!.value == true;
        if(isAdmin == true){
          return AdminHome();
        }
        return ShopHome();
      }

    );
  }
}