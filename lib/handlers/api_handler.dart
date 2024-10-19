
import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiHandler {
  
  Future<Map> uploadFile(String filePath, Map<String, String> metadata) async {
    var url = Uri.parse('https://file.io/?expires=${metadata['expires']}');    
    var request = http.MultipartRequest('POST', url);

    // Adicione o arquivo à requisição
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    // Adicione os campos de metadados à requisição
    request.fields.addAll(metadata);

    try {
      // Enviar a requisição
      var response = await request.send();

      // Ler a resposta
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        // print('Upload bem-sucedido! Resposta: $responseBody');
        return  jsonDecode(responseBody);
        
      } else {
        // print('Falha no upload. Código de status: ${response.statusCode}');
        // print('Resposta: $responseBody');
        return throw Exception(jsonDecode(responseBody)["message"]);
      }
    } catch (e) {
      print('Fail upload: $e');
    }
    
    return {};
  }

}

// {"success":true,"status":200,"id":"70c67d00-1ecd-11ef-99b2-21bbc513faf5","key":"tUVs5gtefVMq","path":"/","nodeType":"file","name":"20230521_112244.jpg","title":null,"description":null,"size":1005745,"link":"https://file.io/tUVs5gtefVMq","private":false,"expires":"2024-05-30T23:41:58.080Z","downloads":0,"maxDownloads":1,"autoDelete":true,"planId":0,"screeningStatus":"pending","mimeType":"application/octet-stream","created":"2024-05-30T21:41:58.080Z","modified":"2024-05-30T21:41:58.080Z"}