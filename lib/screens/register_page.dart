import 'package:final_project/services/auth_service.dart';
import 'package:flutter/material.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
    
  final _auth = AuthService();   
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _loading = false;

  String _error = '';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async{
    setState(() {
      _loading = true;
    });

    
  try{
    await _auth.SignUp(email:_emailCtrl.text.trim() , password:_passCtrl.text , name: _nameCtrl.text.trim(), phone:_phoneCtrl.text.trim() );
    _nameCtrl.clear();
    _emailCtrl.clear();
    _passCtrl.clear();
    _phoneCtrl.clear();

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center   ,
            children: [
              const SizedBox(height: 40),
              Text('cree un compte',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  
                ),
              ),
              const SizedBox(height: 16),
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
                controller: _phoneCtrl,
                decoration: InputDecoration(
                  labelText: 'phone number',
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
                  labelText: 'password',
                  border: OutlineInputBorder(
                    
                     borderRadius: BorderRadius.circular(12)
                  ),
                  
                ),
              ),
              const SizedBox(height: 24),

              if(_error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(_error, style: TextStyle(color: Colors.red),),
                ),
              
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: Text(_loading ? '...' : 'cree un compte'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                ),
              ),
              TextButton(
                onPressed: (){
                  Navigator.pop(context);
                }, child: Text('Have an account ?', ),
                style: TextButton.styleFrom(foregroundColor: Colors.black)
              )
            ],
          ),
        )
      ),
    );
  }
}