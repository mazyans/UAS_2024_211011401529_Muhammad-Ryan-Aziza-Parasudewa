import 'dart:convert';
import 'package:http/http.dart' as http;
import 'crypto.dart';

class ApiService {
  Future<List<Crypto>> fetchCryptoData() async {
    final response =
        await http.get(Uri.parse('https://api.coinlore.net/api/tickers/'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body)['data'];
      return jsonResponse.map((data) => Crypto.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load crypto data');
    }
  }
}
