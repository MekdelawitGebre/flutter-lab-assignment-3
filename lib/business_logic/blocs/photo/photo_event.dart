import 'package:equatable/equatable.dart';

abstract class PhotoEvent extends Equatable {
  const PhotoEvent();

  @override
  List<Object> get props => [];
}

class FetchPhotos extends PhotoEvent {
  final int albumId;

  const FetchPhotos(this.albumId);

  @override
  List<Object> get props => [albumId];
}
