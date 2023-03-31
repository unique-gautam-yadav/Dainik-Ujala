import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dainik_ujala/Backend/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
    required this.data,
  });
  final NewsArtical data;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  _handleShare(String url, String title) async {
    log("askd");
    final box = context.findRenderObject() as RenderBox?;
    try {
      await Share.share(url,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
      log("Done");
    } catch (e) {
      // print(e);
    }
    log("bbasdk");
  }

  Future<bool> _handleUrlTap(String u) async {
    Uri url = Uri.parse(u);

    return await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _handleShare(widget.data.url, widget.data.title);
          },
          child: const Icon(Icons.share_outlined)),
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color.fromARGB(255, 20, 27, 30)
            : Theme.of(context).appBarTheme.backgroundColor,
        title: SizedBox(
          height: (Theme.of(context).textTheme.bodyLarge?.fontSize ?? 0) * 1.5,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: HtmlWidget(
              widget.data.title,
              textStyle: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                opacity: .25,
                image: AssetImage("assets/images/logo.png"),
              )),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Hero(
                    tag: Key("News__${widget.data.id.toString()}"),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: widget.data.urlToImage,
                      placeholder: (context, url) {
                        return Image.asset(
                          "assets/images/logo.jpg",
                          fit: BoxFit.fill,
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Image.asset(
                          "assets/images/logo.jpg",
                          fit: BoxFit.fill,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 0, left: 8, right: 8),
                    child: HtmlWidget(widget.data.title,
                        textStyle: Theme.of(context).textTheme.titleLarge),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0, left: 8, right: 8, bottom: 80),
                    child: HtmlWidget(
                      onTapImage: (p0) {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    ShowImage(url: p0.sources.first.url),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
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
                      },
                      widget.data.content,
                      onTapUrl: (url) {
                        return _handleUrlTap(url);
                      },
                    ),
                  )
                ],
              )),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius:
                      const BorderRadius.only(topRight: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      offset: const Offset(3, 0),
                      blurRadius: 10,
                    ),
                    BoxShadow(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      offset: const Offset(0, 3),
                      blurRadius: 10,
                    ),
                    BoxShadow(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      offset: const Offset(-3, 0),
                      blurRadius: 10,
                    ),
                    BoxShadow(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      offset: const Offset(0, -3),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                      left: 8,
                      right: 12,
                    ),
                    child: Text(DateFormat.jm()
                        .addPattern('; d MMMM y (EEEE)')
                        .format(DateTime.parse(widget.data.publishedAt))))),
          ),
        ],
      ),
    );
  }
}

class ShowImage extends StatefulWidget {
  const ShowImage({super.key, required this.url});

  final String url;

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {
    bool downloaded = false;
    bool downloading = false;
    bool downloadError = false;

    return Scaffold(
      appBar: AppBar(actions: [
        StatefulBuilder(
          builder: (context, setS) {
            return IconButton(
              onPressed: () async {
                if (!downloading && !downloaded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Starting downloading..."),
                    ),
                  );
                  setS(() {
                    downloading = true;
                  });
                  String? res = await ImageDownloader.downloadImage(widget.url);
                  log("$res");
                  if (context.mounted) {
                    if (res != null) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Image downloaded"),
                        ),
                      );
                      setS(() {
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
          },
        )
      ]),
      body: Container(
          decoration:
              BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
          constraints:
              BoxConstraints.expand(height: MediaQuery.of(context).size.height),
          child: Stack(
            children: [
              Positioned(
                  child: PhotoView(
                backgroundDecoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor),
                imageProvider: NetworkImage(widget.url),
              )),
            ],
          )),
    );
  }
}
