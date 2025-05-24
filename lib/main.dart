import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/providers/api_provider.dart';
import 'data/repositories/album_repository.dart';

import 'business_logic/blocs/album/album_bloc.dart';
import 'business_logic/blocs/photo/photo_bloc.dart';

import 'navigation/app_router.dart';

void main() {
  final apiProvider = ApiProvider();
  final albumRepository = AlbumRepository(apiProvider: apiProvider);

  runApp(MyApp(albumRepository: albumRepository));
}

class MyApp extends StatelessWidget {
  final AlbumRepository albumRepository;

  const MyApp({Key? key, required this.albumRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AlbumBloc>(
          create: (_) => AlbumBloc(albumRepository: albumRepository),
        ),
        BlocProvider<PhotoBloc>(
          create: (_) => PhotoBloc(albumRepository: albumRepository),
        ),
      ],
      child: MaterialApp.router(
        title: 'Album App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routerConfig: router, 
      ),
    );
  }
}
