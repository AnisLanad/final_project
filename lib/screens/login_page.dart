import 'package:final_project/screens/register_page.dart';
import 'package:final_project/services/auth_service.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  final _auth = AuthService(); 

  bool _loading = false;
  String _error = '';

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async{
    setState(() {
      _loading = true;
      _error = '';
    });
    
    try {
      await _auth.SignIn(email: _emailCtrl.text, password: _passCtrl.text);
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center   ,
            children: [
              const SizedBox(height: 40),
              Text('se connecter',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailCtrl,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(
                    
                     borderRadius: BorderRadius.circular(12)
                  ),
                  
                ),
              ),
              const SizedBox(height: 24),
              if(_error.isNotEmpty)
                Padding(padding: EdgeInsetsGeometry.only(bottom: 6), child: Text(_error, style: TextStyle(color: Colors.red),),),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit, 
                  child: Text(_loading? '...' : 'Valider'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()),);
                }, child: Text('Cree un compte', ),
                style: TextButton.styleFrom(foregroundColor: Colors.black)
              )
            ],
          ),
        )
      ),
    );
  }
}