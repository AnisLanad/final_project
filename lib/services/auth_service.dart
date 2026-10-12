import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';



class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final DatabaseReference _db = FirebaseDatabase.instance.ref();


  Future<void> SignUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  })async{
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      final uid = credential.user!.uid;

      _db.child('Users').child(uid).set({
        'admin': false,
        'email' : email,
        'name' : name,
        'phone': phone,
      });
  }



  Future<void> SignIn({
    required String email,
    required String password
  })async{
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }
}
