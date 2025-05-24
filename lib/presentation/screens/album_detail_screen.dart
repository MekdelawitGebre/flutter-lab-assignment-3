import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/blocs/photo/photo_bloc.dart';
import '../../business_logic/blocs/photo/photo_event.dart';
import '../../business_logic/blocs/photo/photo_state.dart';
import '../../data/models/album_model.dart';
import 'package:go_router/go_router.dart';

class AlbumDetailScreen extends StatefulWidget {
  final int albumId;
  final Album? album;

  const AlbumDetailScreen({Key? key, required this.albumId, this.album})
      : super(key: key);

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PhotoBloc>().add(FetchPhotos(widget.albumId));
  }

  @override
  Widget build(BuildContext context) {
    final album = widget.album;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Album Details'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // more padding for good look
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (album != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  'Title: ${album.title}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            Text('Album ID: ${widget.albumId}',
                style: const TextStyle(fontSize: 16)),
            if (album != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text('User ID: ${album.userId}',
                    style: const TextStyle(fontSize: 16)),
              ),
            const SizedBox(height: 20),
            const Text('Photos:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<PhotoBloc, PhotoState>(
                builder: (context, state) {
                  if (state is PhotoLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PhotoLoaded) {
                    final photos = state.photos;
                    if (photos.isEmpty) {
                      return const Center(child: Text('No photos found'));
                    }
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: photos.length,
                      itemBuilder: (context, index) {
                        final photo = photos[index];
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[100],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 3,
                                offset: Offset(1, 1),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8)),
                                  child: Image.network(
                                    photo.thumbnailUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 48,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  photo.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is PhotoError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(state.message),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => context
                                .read<PhotoBloc>()
                                .add(FetchPhotos(widget.albumId)),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
