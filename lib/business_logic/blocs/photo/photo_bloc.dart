import 'package:flutter_bloc/flutter_bloc.dart';
import 'photo_event.dart';
import 'photo_state.dart';
import '../../../data/repositories/album_repository.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final AlbumRepository albumRepository;

  PhotoBloc({required this.albumRepository}) : super(PhotoInitial()) {
    on<FetchPhotos>((event, emit) async {
      emit(PhotoLoading());
      try {
        final photos = await albumRepository.getPhotosByAlbumId(event.albumId);
        emit(PhotoLoaded(photos));
      } catch (e) {
        emit(PhotoError(e.toString()));
      }
    });
  }
}
