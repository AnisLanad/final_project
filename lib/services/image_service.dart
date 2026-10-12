import 'dart:convert';
import 'package:http/http.dart' as http;


class  ImageService {
  String _cloudName = 'dmbarpygi';
  String _uploadPreset = 'mini_shop';

  Future<String> uploadImage(String path) async{
    
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', url);
    request.fields['upload_preset'] = _uploadPreset;
    request.files.add(await http.MultipartFile.fromPath('file', path));


    final response = await request.send();
    final body = await response.stream.bytesToString();

    final json = jsonDecode(body) as Map<String,dynamic>;

    return json['secure_url'] as String;
  }

}