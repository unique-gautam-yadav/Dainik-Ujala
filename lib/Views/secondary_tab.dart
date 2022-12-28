import 'package:dainik_ujala/Backend/api.dart';
import 'package:dainik_ujala/Backend/models.dart';
import 'package:dainik_ujala/UI%20Components/compnents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class SecondaryTab extends StatefulWidget {
  const SecondaryTab({
    super.key,
    required this.category,
  });
  final int category;

  @override
  State<SecondaryTab> createState() => _SecondaryTabState();
}

class _SecondaryTabState extends State<SecondaryTab> {
  late List<Widget> newsItems;
  int pageNo = 1;
  bool hasMore = true;
  ScrollController scrollController = ScrollController();

  _loadNews() async {
    Iterable<NewsArtical> d =
        await FetchData.callApi(category: widget.category, page: pageNo);
    setState(() {
      if (d.isNotEmpty) {
        for (int i = 0; i < d.length; i++) {
          Widget one = Article(data: d.elementAt(i), curIndex: i);
          newsItems.add(one);
        }
        pageNo++;
      } else {
        print("Data Ended");
        hasMore = false;
      }
    });
  }

  _handleReload() async {
    setState(() {
      pageNo = 1;
      newsItems.clear();
    });
    await _loadNews();
  }

  @override
  void initState() {
    newsItems = <Widget>[];
    _loadNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      color: Theme.of(context).shadowColor,
      onRefresh: () async {
        _handleReload();
      },
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onPanDown: (details) {
                Future.delayed(const Duration(seconds: 1)).then((value) {
                  if (scrollController.position.maxScrollExtent <=
                      scrollController.offset + 500) {
                    _loadNews();
                  }
                });
              },
              child: Column(
                children: newsItems,
              ),
            ),
            hasMore
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SpinKitSpinningLines(
                      color: Theme.of(context).backgroundColor,
                      size: 50,
                    ))
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
