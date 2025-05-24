import 'package:go_router/go_router.dart';
import '../presentation/screens/album_list_screen.dart';
import '../presentation/screens/album_detail_screen.dart';
import '../data/models/album_model.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AlbumListScreen(),
    ),
    GoRoute(
      path: '/album/:id',
      builder: (context, state) {
       final id = int.parse(state.pathParameters['id']!);

        final Album? album = state.extra as Album?;
        return AlbumDetailScreen(albumId: id, album: album);
      },
    ),
  ],
);
