import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:folks/api/api_helper.dart';
import 'favorite_page.dart';

class PlayingView extends StatefulWidget {
  final DocumentSnapshot<Map<String, dynamic>> folk;
  const PlayingView({required this.folk, Key? key}) : super(key: key);

  @override
  _PlayingViewState createState() => _PlayingViewState();
}

class _PlayingViewState extends State<PlayingView> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late Timer _timer;

  bool isPlaying = false;
  Duration _duration = Duration();
  Duration _position = Duration();
  bool isLiked = false;

  void fetchCurrentLikedStatus() async {
    final status = await ApiHelper.getLiked(folksId: widget.folk.id);
    setState(() {
      isLiked = status;
    });
  }

  @override
  void initState() {
    super.initState();

    fetchCurrentLikedStatus();

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (isPlaying) {
        _audioPlayer.getCurrentPosition().then((position) {
          setState(() {
            _position = position!;
          });
        });
      }
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        setState(() {
          isPlaying = false;
          _position = Duration(seconds: 0);
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  void _addToFavorites() async {
    await ApiHelper.setLiked(folksId: widget.folk.id, isLiked: isLiked);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${!isLiked ? 'Removed from' : 'Added to'} Favorites'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folk.get('Name')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: widget.folk.get('image'),
              height: 250,
              width: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              widget.folk.get('Name'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '${widget.folk.get('duration')} мин',
              style: TextStyle(
                color: Colors.grey.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isPlaying)
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () {
                      _audioPlayer.play(UrlSource(widget.folk.get('mp3url')));
                      setState(() {
                        isPlaying = true;
                      });
                    },
                  ),
                if (isPlaying)
                  IconButton(
                    icon: Icon(Icons.stop),
                    onPressed: () {
                      _audioPlayer.stop();
                      setState(() {
                        isPlaying = false;
                        _position = Duration(seconds: 0);
                      });
                    },
                  ),
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : null,
                  ),
                  onPressed: () {
                    _toggleLike();
                    _addToFavorites();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Slider(
              value: _position.inSeconds.toDouble(),
              max: _duration.inSeconds.toDouble(),
              onChanged: (value) {
                _audioPlayer.seek(Duration(seconds: value.toInt()));
              },
              activeColor: Colors.green,
              inactiveColor: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_position.inMinutes}:${(_position.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '${_duration.inMinutes}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
