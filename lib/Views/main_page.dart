import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dainik_ujala/Views/secondary_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Backend/providers.dart';
import '../UI Components/compnents.dart';
import 'home_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _tabController = TabController(length: 6, vsync: this);
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
                  // pinned: true,
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
                  bottom: TabBar(
                    
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
                    ],
                  ),
                ),
              )
            ],
            body: TabBarView(
              controller: _tabController,
              children: const [
                HomeTab(),
                SecondaryTab(category: 3),
                SecondaryTab(category: 4),
                SecondaryTab(category: 6),
                SecondaryTab(category: 5),
                SecondaryTab(category: 1),
              ],
            ),
          ),
        ),
      );
    });
  }
}
