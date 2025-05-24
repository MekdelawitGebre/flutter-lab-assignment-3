import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/blocs/album/album_bloc.dart';
import '../../business_logic/blocs/album/album_event.dart';
import '../../business_logic/blocs/album/album_state.dart';
import '../../business_logic/blocs/photo/photo_bloc.dart';
import '../../business_logic/blocs/photo/photo_event.dart';
import '../../business_logic/blocs/photo/photo_state.dart';
import '../../data/models/album_model.dart';
import '../../data/models/photo_model.dart';
import '../../presentation/widgets/album_list_item.dart';
import 'package:go_router/go_router.dart';

class AlbumListScreen extends StatefulWidget {
  const AlbumListScreen({Key? key}) : super(key: key);

  @override
  State<AlbumListScreen> createState() => _AlbumListScreenState();
}

class _AlbumListScreenState extends State<AlbumListScreen> {
  // Map to cache first photo per album for thumbnail
  final Map<int, Photo> albumThumbnails = {};

  @override
  void initState() {
    super.initState();
    context.read<AlbumBloc>().add(FetchAlbums());
  }

  Future<void> _loadThumbnailPhotos(List<Album> albums) async {
    for (var album in albums) {
      if (!albumThumbnails.containsKey(album.id)) {
        final photoBloc = context.read<PhotoBloc>();
        photoBloc.add(FetchPhotos(album.id));
        final state = await photoBloc.stream
            .firstWhere((state) => state is! PhotoLoading);
        if (state is PhotoLoaded && state.photos.isNotEmpty) {
          albumThumbnails[album.id] = state.photos.first;
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
      ),
      body: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, state) {
          if (state is AlbumLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlbumLoaded) {
            _loadThumbnailPhotos(state.albums);
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              itemCount: state.albums.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final album = state.albums[index];
                final thumbnail = albumThumbnails[album.id];
                return GestureDetector(
                  onTap: () {
                    context.push('/album/${album.id}', extra: album);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: thumbnail != null
                              ? Image.network(
                                  thumbnail.thumbnailUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.broken_image,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            album.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is AlbumError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<AlbumBloc>().add(FetchAlbums()),
                    child: const Text('Retry'),
                  )
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
