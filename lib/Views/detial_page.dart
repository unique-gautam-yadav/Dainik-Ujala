import 'package:dainik_ujala/Backend/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  DetailPage({
    super.key,
    required this.data,
  }) {
    published = DateTime.parse(data.publishedAt);
  }
  late DateTime published;
  final NewsArtical data;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late DateTime publishDateTime;

  _handleShare(String url, String title) async {
    final box = context.findRenderObject() as RenderBox?;
    try {
      await Share.share(url,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } catch (e) {
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(DateFormat.yMEd().add_jms().format(widget.published)),
          )),
      // bottomSheet: ButtonBar(alignment: MainAxisAlignment.center, children: [
      //   ElevatedButton(
      //     style: ButtonStyle(
      //       backgroundColor:
      //           MaterialStateProperty.all(Theme.of(context).primaryColor),
      //       padding: MaterialStateProperty.all(const EdgeInsets.only(
      //           left: 30, right: 30, top: 10, bottom: 10)),
      //       shape: MaterialStateProperty.all(const StadiumBorder()),
      //     ),
      //     onPressed: () {
      //       Uri uri = Uri.parse(data.url);
      //       launchUrl(uri);
      //     },
      //     child: const Text(
      //       "See full article.",
      //       style: TextStyle(color: Colors.white),
      //     ),
      //   )
      // ]),
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
          height: (Theme.of(context).textTheme.bodyText1?.fontSize ?? 0) * 1.5,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: HtmlWidget(
              widget.data.title,
              textStyle: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
      ),
      body: Container(
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
                child: Image.network(widget.data.urlToImage)

                // Container(
                //     height: MediaQuery.of(context).size.width * 0.67,
                //     width: MediaQuery.of(context).size.width,
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(8),
                //         color: Theme.of(context).backgroundColor,
                //         image: DecorationImage(
                //           image: NetworkImage(data.urlToImage),
                //           fit: BoxFit.cover,
                //         ))),
                ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, bottom: 0, left: 8, right: 8),
              child: HtmlWidget(widget.data.title,
                  textStyle: Theme.of(context).textTheme.headline6),
            ),
            const Divider(),
            Padding(
              padding:
                  const EdgeInsets.only(top: 0, left: 8, right: 8, bottom: 80),
              child: HtmlWidget(widget.data.content),
            )
          ],
        )),
      ),
    );
  }
}
