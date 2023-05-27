import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../UI Components/compnents.dart';
import 'home_tab.dart';
import 'media_view.dart';
import 'secondary_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int curIndex = 0;
  bool hasBanner = false;

  late AnimationController bannerController;
  late Animation<double> blur;
  late Animation<double> position;

  List<Widget> pages = const [NewsTab(), MediaView()];

  @override
  void initState() {
    super.initState();

    bannerController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);

    blur = Tween<double>(begin: 0, end: 6).animate(bannerController)
      ..addListener(() {
        setState(() {});
      });

    position = Tween<double>(begin: 510, end: 0).animate(bannerController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Scaffold(
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
          ),
          hasBanner
              ? Positioned(
                  bottom: 0,
                  top: 0,
                  left: 0,
                  right: 0,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: blur.value, sigmaY: blur.value),
                    child: Container(
                      color: Theme.of(context).dividerColor.withOpacity(.7),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          MainScreenBanner(
            hide: () {
              bannerController.reverse().whenCompleteOrCancel(() {
                setState(() {
                  hasBanner = false;
                });
              });
            },
            show: () {
              setState(() {
                hasBanner = true;
              });
              bannerController.forward();
            },
            position: position,
            hasBanner: hasBanner,
          )
        ],
      ),
    );
  }
}

class MainScreenBanner extends StatefulWidget {
  const MainScreenBanner({
    super.key,
    required this.hide,
    required this.show,
    required this.position,
    required this.hasBanner,
  });

  final VoidCallback hide;
  final VoidCallback show;
  final Animation<double> position;
  final bool hasBanner;

  @override
  State<MainScreenBanner> createState() => _MainScreenBannerState();
}

class _MainScreenBannerState extends State<MainScreenBanner> {
  bool pressed = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 5)).then((value) {
        precacheImage(const AssetImage("assets/images/advt3-min.jpg"), context)
            .then((value) {
          widget.show();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.hasBanner
        ? Positioned(
            left: 30,
            right: 30,
            top: 30,
            bottom: 30,
            child: Transform.translate(
              offset: Offset(0, widget.position.value),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).dialogBackgroundColor,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 55,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 10),
                            const Text("Advertisement"),
                            const Expanded(
                              child: SizedBox.shrink(),
                            ),
                            IconButton.filledTonal(
                              onPressed: () {
                                widget.hide();
                              },
                              icon: const Icon(Icons.close_rounded),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                      Container(
                        height: .5,
                        width: double.infinity,
                        color: Theme.of(context).dividerColor,
                      ),
                      Flexible(
                        child: SizedBox(
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () {
                                widget.hide();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                        "Advertisement description here!!"),
                                  ),
                                );
                              },
                              onTapDown: (details) {
                                setState(() {
                                  pressed = true;
                                });
                              },
                              onTapUp: (details) {
                                setState(() {
                                  pressed = false;
                                });
                              },
                              onTapCancel: () {
                                setState(() {
                                  pressed = false;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 100),
                                foregroundDecoration: BoxDecoration(
                                  color: pressed
                                      ? Theme.of(context)
                                          .dividerColor
                                          .withOpacity(.4)
                                      : Colors.transparent,
                                ),
                                child: Image.asset(
                                  "assets/images/advt3-min.jpg",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )),
                      ),
                      Container(
                        height: .5,
                        width: double.infinity,
                        color: Theme.of(context).dividerColor,
                      ),
                      SizedBox(
                        height: 55,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                elevation:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return null;
                                  }
                                  if (states.contains(MaterialState.pressed)) {
                                    return 0;
                                  } else {
                                    return 2;
                                  }
                                }),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (!states
                                      .contains(MaterialState.disabled)) {
                                    return CupertinoColors.activeBlue;
                                  } else {
                                    return null;
                                  }
                                }),
                                shadowColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (!states
                                      .contains(MaterialState.disabled)) {
                                    return CupertinoColors.activeBlue;
                                  } else {
                                    return null;
                                  }
                                }),
                                foregroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return null;
                                  } else {
                                    return Colors.white;
                                  }
                                }),
                                shape:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return BeveledRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    );
                                  } else {
                                    return BeveledRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    );
                                  }
                                }),
                              ),
                              onPressed: () {},
                              child: const Text("Open"),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                elevation:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return null;
                                  }
                                  if (states.contains(MaterialState.pressed)) {
                                    return 0;
                                  } else {
                                    return 2;
                                  }
                                }),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (!states
                                      .contains(MaterialState.disabled)) {
                                    return null;
                                  } else {
                                    return null;
                                  }
                                }),
                                shape:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return BeveledRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    );
                                  } else {
                                    return BeveledRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    );
                                  }
                                }),
                              ),
                              onPressed: () {
                                widget.hide();
                              },
                              child: const Text("Close"),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
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
    _tabController = TabController(length: 9, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Skelaton(
      tabController: _tabController,
      body: TabBarView(
        controller: _tabController,
        children: const [
          HomeTab(),
          SecondaryTab(category: 3),
          SecondaryTab(category: 4),
          SecondaryTab(category: 6),
          SecondaryTab(category: 5),
          SecondaryTab(category: 1),
          SecondaryTab(category: 55),
          SecondaryTab(category: 56),
          SecondaryTab(category: 58),
        ],
      ),
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
          Tab(height: 40, text: "बिजनेस"),
          Tab(height: 40, text: "शिक्षा / नौकरी"),
          Tab(height: 40, text: "मनोरंजन"),
        ],
      ),
    );
  }
}
