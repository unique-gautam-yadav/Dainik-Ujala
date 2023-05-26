import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dainik_ujala/Backend/firebase_oprations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_view/photo_view.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../Backend/models.dart';
import '../UI Components/compnents.dart';

class MediaView extends StatefulWidget {
  const MediaView({super.key});

  @override
  State<MediaView> createState() => _MediaViewState();
}

class _MediaViewState extends State<MediaView> {
  List<MediaModel>? data;

  getAllMedia() async {
    List<MediaModel>? temp = await FirebaseOperations.getAllPosts();
    setState(() {
      data = temp;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getAllMedia();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Skelaton(
      body: SafeArea(
        child: data != null
            ? data!.isNotEmpty
                ? GridView.builder(
                    itemCount: data!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      return MediaItem(
                        item: data!.elementAt(index),
                      );
                    },
                  )
                : const Center(
                    child: Text("No data found!!"),
                  )
            : Center(
                child: SpinKitSpinningLines(
                color: Theme.of(context).textTheme.bodyLarge!.color!,
                size: 40,
              )),
      ),
    );
  }
}

class MediaItem extends StatefulWidget {
  const MediaItem({
    super.key,
    required this.item,
  });

  final MediaModel item;

  @override
  State<MediaItem> createState() => _MediaItemState();
}

class _MediaItemState extends State<MediaItem> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    return Styled.widget(
      child: MediaDisplay(widget: widget),
    )
        .ripple()
        .padding(all: 2)
        .gestures(onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  PopUpView(
                item: widget.item,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.ease;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          );
        }, onTapChange: (tapState) {
          setState(() {
            pressed = tapState;
          });
        })
        .scale(all: pressed ? 0.95 : 1, animate: true)
        .animate(const Duration(milliseconds: 150), Curves.easeOut);
  }
}

class MediaDisplay extends StatefulWidget {
  const MediaDisplay({
    super.key,
    required this.widget,
  });

  final MediaItem widget;

  @override
  State<MediaDisplay> createState() => _MediaDisplayState();
}

class _MediaDisplayState extends State<MediaDisplay> {
  Uint8List? videoFile;

  firstStep() async {
    try {
      if (widget.widget.item.isVideo) {
        Uint8List? temp = await VideoThumbnail.thumbnailData(
          video:
              "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
          imageFormat: ImageFormat.JPEG,
        );

        if (temp != null) {
          setState(() {
            videoFile = temp;
          });
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    firstStep();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          top: 0,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .color!
                    .withOpacity(.1),
              ),
            ),
            child: !widget.widget.item.isVideo
                ? CachedNetworkImage(
                    imageUrl: widget.widget.item.path!,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, url, progress) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                          value: progress.progress,
                        ),
                      );
                    },
                  )
                : videoFile != null
                    ? Image.memory(
                        videoFile!,
                        fit: BoxFit.cover,
                      )
                    : const Center(
                        child: Text("Loading..."),
                      ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: widget.widget.item.isVideo
              ? Icon(
                  Icons.play_arrow_rounded,
                  size: 75,
                  color: Colors.grey.shade300,
                )
              : Icon(
                  Icons.image,
                  size: 60,
                  color: Colors.grey.shade300,
                ),
        )
      ],
    );
  }
}

class PopUpView extends StatefulWidget {
  const PopUpView({super.key, required this.item});

  final MediaModel item;

  @override
  State<PopUpView> createState() => _PopUpViewState();
}

class _PopUpViewState extends State<PopUpView> {
  VideoPlayerController? videoController;

  @override
  void initState() {
    super.initState();

    if (widget.item.isVideo) {
      videoController = VideoPlayerController.network(widget.item.path!)
        ..initialize().then((_) {
          setState(() {});
        });

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        videoController!.play();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                !widget.item.isVideo
                    ? PhotoView(
                        imageProvider: NetworkImage(widget.item.path!),
                        minScale: PhotoViewComputedScale.contained,
                      )
                    : Center(
                        child: AspectRatio(
                          aspectRatio: videoController!.value.aspectRatio,
                          child: VideoPlayer(
                            videoController!,
                          ),
                        ),
                      ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: widget.item.captions != null &&
                          widget.item.captions!.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade900.withOpacity(.7)
                                    : Colors.grey.shade200.withOpacity(.7),
                            border: Border.all(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey.shade900
                                  : Colors.grey.shade200,
                            ),
                          ),
                          child: Text(widget.item.captions!),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  dispose() {
    if (videoController != null) {
      videoController!.dispose();
    }

    super.dispose();
  }
}
