import 'dart:io';

import 'package:final_project/models%20/product.dart';
import 'package:final_project/services/image_service.dart';
import 'package:final_project/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductForm extends StatefulWidget {
  final Product? existing;
  const ProductForm({super.key, this.existing});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _service = ProductService();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  final _colorCtrl = TextEditingController();
  final _desCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  bool _loading = false;
  String _error = "";
  final _image = ImageService();


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    _colorCtrl.dispose();
    _desCtrl.dispose();
    _imageCtrl.dispose();
  }



  String? _imagePath;
  String _currentImage = '';


  Future<void> _pickImage()async{
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery,maxWidth: 1080);
    if(picked == null) return;
    setState(() {
      _imagePath = picked.path;
    });
  }


  Widget _preview(){
    if(_imagePath != null){
      return Image.file(File(_imagePath!), fit : BoxFit.contain);
       
    }
     if(_currentImage.isNotEmpty){
      return Image.network(_currentImage,fit : BoxFit.contain );
    }
     return Center(child: Text('ajouter une image'),);
   
    
  }


  Future<void> _save() async {

    final name = _nameCtrl.text.trim();
    final price = int.tryParse(_priceCtrl.text.trim());
    final stock = int.tryParse(_stockCtrl.text.trim());
    final color = _colorCtrl.text.trim();
    final description = _desCtrl.text.trim();
    final image = _imageCtrl.text.trim();
    var imagePath = _imagePath;
    setState(() {
      _loading = true;
    });
    
    if(imagePath == null){
      imagePath = '';
    }

    try {
      var imageUrl = '';
      if(imagePath.isNotEmpty){
        imageUrl = await _image.uploadImage(imagePath);
      }else{
        imageUrl = _currentImage;
      }
        
        String id = '';
        final pd = widget.existing;
        if(pd != null){
            id = pd.productId;
        }

        final product = Product(productId:id, name: name, description: description, color: color, price: price, nbItems: stock, productImage: imageUrl);
        String message = '';
        if(pd == null){
          await _service.addProduct(product);
          message = "produit ajouter";
        }else {
          await _service.updateProduct(product);
          message = "produit mis a jour";
        }
        

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message))
        );
        Navigator.pop(context);
    }catch(e){
        setState(() {
          _error = e.toString();
          _loading = false;
        });
    }


  }


  @override
  void initState() {
    
    super.initState();
    final p = widget.existing;
    if(p != null){
      _nameCtrl.text = p.name;
      _priceCtrl.text = p.price.toString();
      _stockCtrl.text = p.nbItems.toString();
      _colorCtrl.text = p.color;
      _desCtrl.text = p.description;
      _currentImage = p.productImage;
    }
  }






  @override
  Widget build(BuildContext context) {
    String pageTitle = 'Nouveau produit';
    if(widget.existing != null){
      pageTitle = 'Modifier produit';
    }
    String btnTitle = 'add product';
    if(widget.existing != null){
      btnTitle = 'update product';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: SafeArea(child: ListView(
        padding: EdgeInsets.all(24),
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(
              labelText: 'Nom',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)
              )

            ),
          ),
          SizedBox(height: 16,),
          TextField(
            controller: _priceCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Prix',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)
              )

            ),
          ),
          SizedBox(height: 16,),
          TextField(
            controller: _stockCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Stock',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)
              )

            ),
          ),
          SizedBox(height: 16,),
          TextField( 
            controller: _colorCtrl,
            decoration: InputDecoration(
              labelText: 'Couleur',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)
              )

            ),
          ),
          SizedBox(height: 16,),
          TextField(
            controller: _desCtrl,
            decoration: InputDecoration(
              labelText: 'description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12)
              )

            ),
          ),
          SizedBox(height: 16,),
          GestureDetector(
            onTap: _loading ? null : _pickImage,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12)
              ),
              child: _preview(),
            ),
          ),
           const SizedBox(height: 24),

              if(_error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(_error, style: TextStyle(color: Colors.red),),
                ),
          SizedBox(height: 21,),

          ElevatedButton(
            onPressed: (){
              _loading ? null : _save();
            }, 
            child: Text(_loading ? '...': btnTitle),style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
          )


        ],
      )),
    );
  }
}