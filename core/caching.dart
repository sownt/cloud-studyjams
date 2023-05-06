import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Caching {
  const Caching({required this.url});

  final String url;

  Future<String> load() async {
    final fileName = Uri.parse(url).pathSegments.last;
    File file;
    if (await File('.tmp/cached/$fileName').exists()) {
      file = File('.tmp/cached/$fileName');
      return utf8.decode(await file.readAsBytes());
    } else {
      file = await File('.tmp/cached/$fileName').create(recursive: true);
      final response = await http.Client().get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bodyString = utf8.decode(response.bodyBytes);
        await file.writeAsString(bodyString);
        return bodyString;
      }
    }
    return '';
  }
}