import 'package:flutter/material.dart';
import '../../data/models/album_model.dart';
import '../../data/models/photo_model.dart';

class AlbumListItem extends StatelessWidget {
  final Album album;
  final Photo? thumbnailPhoto;
  final VoidCallback onTap;

  const AlbumListItem({
    Key? key,
    required this.album,
    this.thumbnailPhoto,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Row(
          children: [
            thumbnailPhoto != null
                ? Image.network(
                    thumbnailPhoto!.thumbnailUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[300],
                    child: const Icon(Icons.photo, size: 30),
                  ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                album.title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
