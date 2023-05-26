import 'dart:developer';

import 'package:dainik_ujala/Backend/api.dart';
import 'package:dainik_ujala/Backend/models.dart';
import 'package:dainik_ujala/UI%20Components/compnents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    Iterable<NewsArtical> d = await FetchData.callApi(
      category: widget.category,
      page: pageNo,
      context: context,
      mounted: mounted,
    );
    if (mounted) {
      setState(() {
        if (d.isNotEmpty) {
          for (int i = 0; i < d.length; i++) {
            Widget one = Article(data: d.elementAt(i), curIndex: i);
            newsItems.add(one);
          }
          pageNo++;
        } else {
          log("Data Ended");
          hasMore = false;
        }
      });
    }
  }

  _handleRefresh() async {
    setState(() {
      pageNo = 1;
    });
    Iterable<NewsArtical> d = await FetchData.callApi(
      category: widget.category,
      page: pageNo,
      context: context,
      mounted: mounted,
    );

    if (mounted) {
      setState(() {
        if (d.isNotEmpty) {
          newsItems.clear();
          for (int i = 0; i < d.length; i++) {
            Widget one = Article(data: d.elementAt(i), curIndex: i);
            newsItems.add(one);
          }
          pageNo++;
        } else {
          log("Data Ended");
          hasMore = false;
        }
      });
    }
  }

  @override
  void initState() {
    newsItems = <Widget>[];
    _loadNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return newsItems.isNotEmpty
        ? RefreshIndicator(
            onRefresh: () async {
              newsItems.clear();
              await _handleRefresh();
            },
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onPanDown: hasMore
                        ? (details) {
                            Future.delayed(const Duration(seconds: 1))
                                .then((value) {
                              if (scrollController.hasClients) {
                                if (scrollController.position.maxScrollExtent <=
                                    scrollController.offset + 500) {
                                  _loadNews();
                                }
                              }
                            });
                          }
                        : null,
                    child: Column(
                      children: newsItems,
                    ),
                  ),
                  hasMore
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SpinKitSpinningLines(
                            color:
                                Theme.of(context).textTheme.bodyLarge!.color!,
                            size: 50,
                          ))
                      : const SizedBox.shrink()
                ],
              ),
            ),
          )
        : Center(
            child: SpinKitSpinningLines(
              color: Theme.of(context).textTheme.bodyLarge!.color!,
              size: 50,
            ),
          );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
