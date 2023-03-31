import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dainik_ujala/Views/secondary_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Backend/providers.dart';
import '../UI Components/compnents.dart';
import 'home_tab.dart';
import 'media_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int curIndex = 0;

  @override
  void initState() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet) {
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Back Online!!")));
      } else {
        ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
            content: const Text("You are offline"),
            backgroundColor: Theme.of(context).hoverColor,
            leading: Icon(
              Icons.info,
              color: Theme.of(context).colorScheme.error,
            ),
            actions: [
              TextButton(onPressed: () {}, child: const Text("Retry"))
            ]));
      }
    });
    super.initState();
  }

  List<Widget> pages = const [NewsTab(), MediaView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: curIndex,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.newspaper_outlined),
              label: "News",
              selectedIcon: Icon(Icons.newspaper_rounded)),
          NavigationDestination(
              icon: Icon(Icons.photo_library_outlined),
              label: "Media",
              selectedIcon: Icon(Icons.photo_library_rounded)),
        ],
        onDestinationSelected: (value) {
          setState(() {
            curIndex = value;
          });
        },
      ),
      body: pages[curIndex],
    );
  }
}

class NewsTab extends StatefulWidget {
  const NewsTab({
    super.key,
  });

  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _tabController = TabController(length: 7, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Skelaton(scaffoldKey: scaffoldKey, tabController: _tabController);
  }
}

class Skelaton extends StatelessWidget {
  const Skelaton({
    super.key,
    required this.scaffoldKey,
    TabController? tabController,
  }) : _tabController = tabController;

  final GlobalKey<State<StatefulWidget>> scaffoldKey;
  final TabController? _tabController;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, value, child) {
      return DefaultTabController(
        length: 6,
        child: Scaffold(
          key: scaffoldKey,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  pinned: true,
                  actions: [
                    IconButton(
                      onPressed: () {
                        value.isDark
                            ? value.isDark = false
                            : value.isDark = true;
                      },
                      icon: Icon(value.isDark
                          ? CupertinoIcons.moon_fill
                          : CupertinoIcons.sun_max_fill),
                    ),
                    const PopUpMenu()
                  ],
                  title: SizedBox(
                      height: 55, child: Image.asset("assets/images/logo.png")),
                  bottom: _tabController != null ? TabBar(
                    padding: const EdgeInsets.all(3),
                    isScrollable: true,
                    controller: _tabController,
                    tabs: const [
                      Tab(height: 40, text: "Home"),
                      Tab(height: 40, text: "बृज समाचार"),
                      Tab(height: 40, text: "प्रदेश"),
                      Tab(height: 40, text: "खेल"),
                      Tab(height: 40, text: "देश-विदेश"),
                      Tab(height: 40, text: "पंचांग-राशिफल"),
                      Tab(height: 40, text: "बिजनेस")
                    ],
                  ) : null,
                ),
              )
            ],
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 95),
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    HomeTab(),
                    SecondaryTab(category: 3),
                    SecondaryTab(category: 4),
                    SecondaryTab(category: 6),
                    SecondaryTab(category: 5),
                    SecondaryTab(category: 1),
                    SecondaryTab(category: 55),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
