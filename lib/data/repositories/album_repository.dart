import '../models/album_model.dart';
import '../models/photo_model.dart';
import '../providers/api_provider.dart';

class AlbumRepository {
  final ApiProvider apiProvider;

  AlbumRepository({required this.apiProvider});

  Future<List<Album>> getAlbums() async {
    return await apiProvider.fetchAlbums();
  }

  Future<List<Photo>> getPhotosByAlbumId(int albumId) async {
    return await apiProvider.fetchPhotosByAlbumId(albumId);
  }
}
