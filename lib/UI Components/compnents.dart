import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dainik_ujala/Backend/models.dart';
import 'package:dainik_ujala/Views/detial_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Backend/providers.dart';

class PopUpMenu extends StatelessWidget {
  const PopUpMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(itemBuilder: (context) {
      return [
        const PopupMenuItem<int>(
          value: 0,
          child: Text("Privacy Policy"),
        ),
      ];
    }, onSelected: (value) async {
      if (value == 0) {
        var url = Uri.parse("https://sites.google.com/view/dainik-ujala/home/");
        await launchUrl(url);
      }
    });
  }
}

class RoundedImage extends StatefulWidget {
  const RoundedImage({
    Key? key,
    required this.artical,
  }) : super(key: key);
  final NewsArtical artical;

  @override
  State<RoundedImage> createState() => _RoundedImageState();
}

class _RoundedImageState extends State<RoundedImage> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Styled.widget(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  DetailPage(
                data: widget.artical,
                bri: Theme.of(context).brightness,
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
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * (9 / 16),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: widget.artical.urlToImage,
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
                  )),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(.2),
                      border: const Border(
                          top: BorderSide(color: Colors.blueGrey, width: 1))),
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 4, bottom: 8, left: 8, right: 2),
                        child: HtmlWidget(
                          widget.artical.title,
                          textStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    )
        .gestures(
          onTapChange: (tapStatus) => setState(() => pressed = tapStatus),
        )
        .scale(all: pressed ? 0.95 : 1.0, animate: true)
        .animate(const Duration(milliseconds: 150), Curves.easeOut);
  }
}

class Article extends StatefulWidget {
  const Article({
    Key? key,
    required this.data,
    required this.curIndex,
  }) : super(key: key);

  final NewsArtical data;
  final int curIndex;

  @override
  State<Article> createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    return Styled.widget(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  DetailPage(
                data: widget.data,
                bri: Theme.of(context).brightness,
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
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 70,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
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
                              return Opacity(
                                opacity: .8,
                                child: Image.asset(
                                  "assets/images/logo.jpg",
                                  fit: BoxFit.fill,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Text(
                        durationToTime(
                          DateTime.now().difference(
                            DateTime.parse(widget.data.publishedAt),
                          ),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: HtmlWidget("<b>${widget.data.title}</b>"),
                  )
                ],
              ),
              widget.data.categoriesStr.isNotEmpty
                  ? Divider(color: Colors.grey.withOpacity(.2))
                  : const SizedBox(),
              widget.data.categoriesStr.isNotEmpty
                  ? SizedBox(
                      height: 30,
                      width: MediaQuery.of(context).size.width - 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.data.categoriesStr.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              ArticleType(
                                  text: widget.data.categoriesStr[index]),
                              widget.data.categoriesStr.length != 1 &&
                                      index !=
                                          widget.data.categoriesStr.length - 1
                                  ? Container(
                                      margin: const EdgeInsets.only(
                                        left: 8,
                                        right: 8,
                                      ),
                                      height: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .fontSize,
                                      width: 3,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          );
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    )
        .ripple(
            splashColor: Theme.of(context).brightness == Brightness.light
                ? Colors.grey
                : null)
        .elevation(
          pressed ? 0 : 0.1,
          shadowColor: Theme.of(context).brightness == Brightness.light
              ? Colors.grey.shade50.withOpacity(.4)
              : Colors.black,
        )
        .clipRRect(all: 12)
        .padding(all: 12)
        .gestures(
          onTapChange: (tapStatus) => setState(() => pressed = tapStatus),
        )
        .scale(all: pressed ? 0.95 : 1.0, animate: true)
        .animate(const Duration(milliseconds: 150), Curves.easeOut);
  }
}

class ArticleType extends StatelessWidget {
  const ArticleType({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      text,
      style: TextStyle(
        decoration: TextDecoration.underline,
        color: Theme.of(context).colorScheme.primary,
        decorationColor: Theme.of(context).colorScheme.primary,
        decorationThickness: 3,
        fontWeight: FontWeight.bold,
      ),
    ));
  }
}

class Skelaton extends StatelessWidget {
  const Skelaton({
    super.key,
    TabController? tabController,
    this.bottom,
    required this.body,
  });

  final PreferredSizeWidget? bottom;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, value, child) {
      return DefaultTabController(
          length: 6,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    value.isDark ? value.isDark = false : value.isDark = true;
                  },
                  icon: Icon(value.isDark
                      ? CupertinoIcons.moon_fill
                      : CupertinoIcons.sun_max_fill),
                ),
                const PopUpMenu()
              ],
              title: SizedBox(
                  height: 55, child: Image.asset("assets/images/logo.png")),
              bottom: bottom,
            ),
            body: body,
          ));
    });
  }
}

String durationToTime(Duration duration) {
  if (duration.inDays > 365) {
    return "${duration.inDays ~/ 365}y";
  }
  if (duration.inDays > 30) {
    return "${duration.inDays ~/ 30}mth";
  }
  if (duration.inDays > 7) {
    return "${duration.inDays ~/ 7}w";
  }
  if (duration.inHours > 24) {
    return "${duration.inDays}d";
  }
  if (duration.inMinutes > 24) {
    return "${duration.inHours}h";
  }
  if (duration.inSeconds > 59) {
    return "${duration.inMinutes}m";
  }
  if (duration.inSeconds < 59) {
    return "${duration.inSeconds}s";
  }
  return "";
}
