import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dainik_ujala/Backend/firebase_oprations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:zoom_widget/zoom_widget.dart';

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
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color:
                Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.1),
          ),
        ),
        child: CachedNetworkImage(
          imageUrl: widget.item.path!,
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
        ),
      ),
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
              ));
          // showModalBottomSheet(
          //   context: context,
          //   builder: (context) => const PopUpView(),
          // );
        }, onTapChange: (tapState) {
          setState(() {
            pressed = tapState;
          });
        })
        .scale(all: pressed ? 0.95 : 1, animate: true)
        .animate(const Duration(milliseconds: 150), Curves.easeOut);
  }
}

class PopUpView extends StatelessWidget {
  const PopUpView({super.key, required this.item});

  final MediaModel item;

  @override
  Widget build(BuildContext context) {
    bool downloaded = false;
    bool downloading = false;
    bool downloadError = false;
    return Material(
      child: SafeArea(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              ButtonBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                    ),
                  ),
                  StatefulBuilder(builder: (context, setState) {
                    return IconButton(
                      onPressed: () async {
                        if (!downloading && !downloaded) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Starting downloading..."),
                            ),
                          );
                          setState(() {
                            downloading = true;
                          });
                          String? res =
                              await ImageDownloader.downloadImage(item.path!);
                          log("$res");
                          if (context.mounted) {
                            if (res != null) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Image downloaded"),
                                ),
                              );
                              setState(() {
                                downloaded = true;
                                downloading = false;
                              });
                            } else {
                              setState(() {
                                downloadError = true;
                                downloaded = false;
                                downloading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Something went wrong"),
                                ),
                              );
                            }
                          }
                        }
                      },
                      icon: downloading
                          ? const Icon(Icons.downloading_rounded)
                          : downloaded
                              ? const Icon(Icons.download_done_rounded)
                              : downloadError
                                  ? const Icon(Icons.file_download_off_rounded)
                                  : const Icon(Icons.download_rounded),
                    );
                  })
                ],
              ),
              Expanded(
                child: Stack(
                  children: [
                    Zoom(
                        initTotalZoomOut: true,
                        backgroundColor: Colors.transparent,
                        child: CachedNetworkImage(
                          imageUrl: item.path!,
                          progressIndicatorBuilder: (context, url, progress) {
                            return CircularProgressIndicator(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                              value: progress.progress,
                            );
                          },
                        )),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: item.captions != null && item.captions!.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.grey.shade900.withOpacity(.7)
                                    : Colors.grey.shade200.withOpacity(.7),
                                border: Border.all(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey.shade900
                                      : Colors.grey.shade200,
                                ),
                              ),
                              child: Text(item.captions!),
                            )
                          : const SizedBox.shrink(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
