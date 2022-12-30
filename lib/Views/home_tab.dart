import 'dart:async';

import 'package:dainik_ujala/Backend/api.dart';
import 'package:dainik_ujala/Backend/models.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../UI Components/compnents.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late List<Widget> sliderItems;
  late List<Widget> newsItems;

  ScrollController scrollController = ScrollController();

  int pageNo = 1;
  bool hasMore = true;

  _loadNews() async {
    Iterable<NewsArtical> d = await FetchData.callApi(page: pageNo);
    setState(() {
      if (d.isNotEmpty) {
        for (int i = 0; i < d.length; i++) {
          Widget one = Article(data: d.elementAt(i), curIndex: i);
          newsItems.add(one);
        }
        pageNo++;
      } else {
        // print("Data Ended");
        hasMore = false;
      }
    });
  }

  _loadHeadlines() async {
    Iterable<NewsArtical> d = await FetchData.callApi(page: 1);
    setState(() {
      for (int i = 0; i < d.length; i++) {
        Widget one = RoundedImage(
          artical: d.elementAt(i),
        );
        sliderItems.add(one);
      }
    });
  }

  _handleReload() async {
    setState(() {
      pageNo = 1;
      sliderItems.clear();
      newsItems.clear();
    });
    await _loadHeadlines();
    await _loadNews();
  }

  @override
  void initState() {
    super.initState();
    sliderItems = <Widget>[];
    newsItems = <Widget>[];
    _loadHeadlines();
    _loadNews();
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
          children: [
            Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CarouselSlider(
                      items: sliderItems.isNotEmpty
                          ? sliderItems
                          : [
                              Center(
                                child: SpinKitSpinningLines(
                                  color: Theme.of(context).backgroundColor,
                                  size: 50,
                                ),
                              )
                            ],
                      options: CarouselOptions(
                          autoPlay: sliderItems.isNotEmpty ? true : false,
                          enlargeCenterPage: true,
                          disableCenter: true,
                          autoPlayInterval: const Duration(seconds: 5)),
                    ))),
            const SizedBox(height: 2),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: newsItems),
            ),
            hasMore & (pageNo > 1)
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
