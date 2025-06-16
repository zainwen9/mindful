import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mental_health/core/theme.dart';
import 'package:mental_health/features/music/domain/entitites/song.dart';
import 'package:mental_health/features/music/presentation/bloc/song_bloc.dart';
import 'package:mental_health/features/music/presentation/pages/music_player_screen.dart';

import '../../../../resources/app_colors.dart';
import '../../../music/presentation/bloc/song_event.dart';
import '../../../music/presentation/bloc/song_state.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundColor,
      body: SafeArea(
        child: BlocBuilder<SongBloc, SongState>(
          builder: (context, state) {
            if (state is SongLoading) {
              return _buildLoadingState();
            } else if (state is SongLoaded) {
              return _buildLoadedState(context, state);
            } else if (state is SongLoadFailure) {
              return _buildErrorState(context, state.message);
            } else {
              return _buildEmptyState(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            child: LottieBuilder.network(
              "https://lottie.host/65bd2e51-261e-4712-a5bd-38451aac4977/viHIqd4hxU.json",
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Loading your vibe...",
            style: TextStyle(
              color: ColorManager.bubbleColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, SongLoaded state) {
    return Column(
      children: [
        _buildAppBar(context),
        const SizedBox(height: 10),
        _buildPlaylistHeader(),
        Expanded(
          child: _buildSongsList(context, state.songs),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorManager.buttonColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: ColorManager.buttonColor,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Text(
            'My Chill Playlist',
            style: TextStyle(
              color: ColorManager.buttonColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.more_vert,
            color: ColorManager.buttonColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorManager.bubbleColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ColorManager.bubbleColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.buttonColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
              image: const DecorationImage(
                image: NetworkImage("https://images.unsplash.com/photo-1494232410401-ad00d5433cfa"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Relaxation Mode",
                  style: TextStyle(
                    color: ColorManager.buttonColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Sounds to help you unwind and find your peace",
                  style: TextStyle(
                    color: ColorManager.buttonColor.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.music_note, size: 14, color: ColorManager.buttonColor),
                    const SizedBox(width: 5),
                    Text(
                      "28 tracks",
                      style: TextStyle(
                        color: ColorManager.buttonColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.access_time, size: 14, color: ColorManager.buttonColor),
                    const SizedBox(width: 5),
                    Text(
                      "1hr 45min",
                      style: TextStyle(
                        color: ColorManager.buttonColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongsList(BuildContext context, List<Song> songs) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: ColorManager.bubbleColor.withOpacity(0.15),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All Tracks",
                  style: TextStyle(
                    color: ColorManager.buttonColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: ColorManager.buttonColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.play_arrow, color: Colors.white, size: 18),
                      const SizedBox(width: 5),
                      Text(
                        "Play All",
                        style: TextStyle(
                          color: ColorManager.backgroundColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final delay = index * 0.2;
                    final slideAnimation = Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Interval(
                          delay.clamp(0.0, 0.9),
                          (delay + 0.4).clamp(0.0, 1.0),
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                    );
                    return SlideTransition(
                      position: slideAnimation,
                      child: _buildSongTile(context, song),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongTile(BuildContext context, Song song) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MusicPlayerScreen(song: song),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: ColorManager.bubbleColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: ColorManager.buttonColor.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Hero(
                tag: 'song_image_${song.title}',
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(song.imageid),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      style: TextStyle(
                        color: ColorManager.buttonColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      song.author,
                      style: TextStyle(
                        color: ColorManager.buttonColor.withOpacity(0.7),
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: ColorManager.buttonColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: ColorManager.buttonColor,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            child: LottieBuilder.network(
              "https://lottie.host/fc2bc940-1d88-4ea2-8d5d-791e6480760e/4oA0NKLXn3.json",
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              color: ColorManager.bubbleColor,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              context.read<SongBloc>().add( FetchSongs());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.buttonColor,
              foregroundColor: ColorManager.backgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text("Try Again"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
            child: LottieBuilder.network(
              "https://lottie.host/628ae316-ce58-4c02-a205-d29fe845a04a/DsXepW48Af.json",
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Your playlist is empty",
            style: TextStyle(
              color: ColorManager.bubbleColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Let's add some relaxing tracks",
            style: TextStyle(
              color: ColorManager.bubbleColor.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              context.read<SongBloc>().add( FetchSongs());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.buttonColor,
              foregroundColor: ColorManager.backgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 5,
            ),
            child: const Text(
              "Browse Music",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}