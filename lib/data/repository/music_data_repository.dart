
import 'package:vk_music/data/service/vk_service.dart';
import 'package:vk_music/domain/models/song.dart';
import 'package:vk_music/domain/repository/music_repository.dart';

import '../../domain/models/playlist.dart';

class MusicDataRepository implements MusicRepository {
  final VKService _api;

  MusicDataRepository(this._api);

  @override
  Future getMusic(String args) => _api.getMusic(args);

  @override
  Future<void> deleteAudio(Song song) => _api.deleteAudio(song);

  @override
  Future<void> addAudio(Song song) => _api.addAudio(song);

  @override
  Future<void> reorder(Song song, {String? before, String? after}) => _api.reorder(song, before: before, after: after);

  @override
  Future getPlaylists(String args) => _api.getPlaylists(args);

  @override
  Future getPlaylistMusic(Playlist playlist) => _api.getPlaylistMusic(playlist);

  @override
  Future<void> deleteFromPlaylist({required Playlist playlist, required List<Song> songsToDelete}) =>
      _api.deleteFromPlaylist(playlist: playlist, songsToDelete: songsToDelete);

  @override
  Future savePlaylist(
      {required Playlist playlist, String? title, String? description, List<Song>? songsToAdd, List? reorder}
  ) => _api.savePlaylist(playlist: playlist, title: title, description: description, songsToAdd: songsToAdd, reorder: reorder);

  @override
  Future<dynamic> addAudiosToPlaylist(Playlist playlist, List<String> audiosToAdd) => _api.addAudiosToPlaylist(playlist, audiosToAdd);

  @override
  Future search(String q, {int? count, int? offset}) => _api.search(q, count: count, offset: offset);

  @override
  Future searchAlbum(String q) => _api.searchAlbum(q);

  @override
  Future searchPlaylist(String q) {
    // TODO: implement searchPlaylist
    throw UnimplementedError();
  }

  @override
  Future getRecommendations({int? offset}) => _api.getRecommendations(offset: offset);

  @override
  Future<void> followPlaylist(Playlist playlist) => _api.followPlaylist(playlist);

  @override
  Future<void> deletePlaylist(Playlist playlist) => _api.deletePlaylist(playlist);
}