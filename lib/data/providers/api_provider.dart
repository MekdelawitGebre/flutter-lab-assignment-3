import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/album_model.dart';
import '../models/photo_model.dart';

class ApiProvider {
  final http.Client httpClient;

  ApiProvider({http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  Future<List<Album>> fetchAlbums() async {
    final response = await httpClient
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

    if (response.statusCode == 200) {
      final List jsonList = json.decode(response.body);
      return jsonList.map((json) => Album.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load albums');
    }
  }

  Future<List<Photo>> fetchPhotosByAlbumId(int albumId) async {
    final response = await httpClient.get(
      Uri.parse('https://jsonplaceholder.typicode.com/photos?albumId=$albumId'),
    );

    if (response.statusCode == 200) {
      final List jsonList = json.decode(response.body);
      return jsonList.map((json) => Photo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }
}
