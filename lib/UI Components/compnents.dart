// ignore_for_file: avoid_print

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dainik_ujala/Backend/models.dart';
import 'package:dainik_ujala/Views/detial_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(data: widget.artical),
            ));
      },
      child: Hero(
        tag: Key(widget.artical.id.toString()),
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
    );
  }
}

class Article extends StatelessWidget {
  const Article({
    Key? key,
    required this.data,
    required this.curIndex,
  }) : super(key: key);

  final NewsArtical data;
  final int curIndex;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(data: data),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Hero(
                          tag: Key("News__${data.id.toString()}"),
                          child: SizedBox(
                            width: 120,
                            height: 70,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl: data.urlToImage,
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
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: HtmlWidget(data.title),
                    )
                  ],
                ),
                data.categoriesStr.isNotEmpty
                    ? Divider(color: Colors.grey.withOpacity(.2))
                    : const SizedBox(),
                data.categoriesStr.isNotEmpty
                    ? SizedBox(
                        height: 45,
                        width: MediaQuery.of(context).size.width - 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.categoriesStr.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child:
                                  ArticleType(text: data.categoriesStr[index]),
                            );
                          },
                        ),
                      )
                    : const SizedBox(),
                // ListTile(
                //   title: Text(data.title),
                //   subtitle: SizedBox(
                //     height: 45,
                //     child: ListView.builder(
                //       scrollDirection: Axis.horizontal,
                //       itemCount: data.categoriesStr.length,
                //       itemBuilder: (context, index) {
                //         return ArticleType(text: data.categoriesStr[index]);
                //       },
                //     ),
                //   ),
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => DetailPage(data: data),
                //         ));
                //   },
                //   leading: Hero(
                //     tag: Key("News__${data.id.toString()}"),
                //     child: Container(
                //       width: 100,
                //       height: 100,
                //       decoration: BoxDecoration(
                //         color: Theme.of(context).backgroundColor.withOpacity(.8),
                //         borderRadius: BorderRadius.circular(10),
                //         // image: DecorationImage(
                //         //     image: NetworkImage(data.urlToImage), fit: BoxFit.cover),
                //       ),
                //       // child: Center(
                //       //     child: Text(
                //       //   "${data.categoriesStr.toString()}",
                //       //   style: TextStyle(
                //       //     color: Colors.white,
                //       //     fontSize: 25,
                //       //   ),
                //       // )),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChipText extends StatelessWidget {
  const ChipText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color:
              Theme.of(context).textTheme.titleMedium!.color!.withOpacity(.5)),
    );
  }
}

class CustomChip extends StatelessWidget {
  const CustomChip({
    Key? key,
    required this.label,
  }) : super(key: key);
  final Widget label;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).shadowColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(500)),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 8,
          bottom: 8,
        ),
        child: label,
      ),
    );
  }
}

class ArticleType extends StatelessWidget {
  const ArticleType({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.3),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(child: Text(text)),
    );
  }
}
