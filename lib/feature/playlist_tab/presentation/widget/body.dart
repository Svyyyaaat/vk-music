import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_music/core/presentation/cover.dart';
import 'package:vk_music/feature/playlist_tab/presentation/widget/playlist_edit_screen.dart';
import '../../../../core/domain/const.dart';
import '../../../../core/domain/models/player_playlist.dart';
import '../../../../core/domain/models/playlist.dart';
import '../../../../core/domain/state/music_player/music_player_cubit.dart';
import '../../../playlists_tab/domain/state/playlists_cubit.dart';
import '../../../song_list/music_list.dart';
import '../../domain/state/playlist_cubit.dart';

class PlaylistTabBody extends StatelessWidget {
  const PlaylistTabBody(this.playlist, {super.key});

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    final cubit = PlaylistCubit()..loadPlaylist(playlist);
    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<PlaylistCubit, PlaylistState>(
        builder: (context, state) {
          if (state is! PlaylistLoadedState) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
              child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).padding.top,
                color: Colors.black,
              ),
              CoverWidget(photoUrl: state.playlist.photoUrl600, size: 250),
              _TitleWidget(state.playlist.title),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                      onPressed: () {
                        context.read<MusicPlayerCubit>().play(
                            song: state.songs.first,
                            playlist: PlayerPlaylist.formSongList(state.songs));
                      },
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Слушать')),
                  const SizedBox(width: 8),
                  playlist.isOwner
                      ? _EditPlaylistButton(playlist)
                      : const SizedBox.shrink(),
                  playlist.isOwner
                      ? const SizedBox.shrink()
                      : _FollowButton(playlist)
                ],
              ),
              playlist.description != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(playlist.description!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white)),
                    )
                  : const SizedBox.shrink(),
              const Divider(),
              MusicList(songs: state.songs, withMenu: true),
              SizedBox(
                // Add this
                height:
                    kToolbarHeight + (MediaQuery.of(context).padding.bottom),
              ),
            ],
          ));
        },
      ),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    );
  }
}

class _EditPlaylistButton extends StatelessWidget {
  const _EditPlaylistButton(this.playlist, {super.key});

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
            onPressed: () => navigatorKey.currentState!.push(
                MaterialPageRoute(builder: (_) => PlaylistEdit(playlist))),
            icon: const Icon(Icons.edit_rounded),
            label: const Text('Изменить')));
  }
}

class _FollowButton extends StatelessWidget {
  const _FollowButton(this.playlist, {super.key});
  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<PlaylistsCubit>();
    return playlist.isFollowing
        ? SizedBox(
            width: 90,
            child: IconButton.filled(
              onPressed: () => cubit.deletePlaylist(playlist),
              icon: const Icon(Icons.check_rounded),
              style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
                backgroundColor: const MaterialStatePropertyAll(
                    Color.fromARGB(255, 20, 20, 20)),
                foregroundColor: const MaterialStatePropertyAll(Colors.white),
              ),
            ),
          )
        : ElevatedButton.icon(
            onPressed: () => cubit.followPlaylist(playlist),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Добавить'),
            style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
              backgroundColor: const MaterialStatePropertyAll(
                  Color.fromARGB(255, 20, 20, 20)),
              foregroundColor: const MaterialStatePropertyAll(Colors.white),
            ),
          );
  }
}
