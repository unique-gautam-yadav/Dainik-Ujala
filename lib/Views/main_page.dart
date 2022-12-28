import 'package:dainik_ujala/Views/secondary_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  bool isDarkTheme = true;

  updateThemeDetails() async {
    Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {
        isDarkTheme =
            MediaQuery.of(context).platformBrightness == Brightness.dark;
      });
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title:
            SizedBox(height: 55, child: Image.asset("assets/images/logo.png")),
        bottom: TabBar(
          padding: const EdgeInsets.all(3),
          isScrollable: true,
          indicatorWeight: 0,
          labelPadding:
              const EdgeInsets.only(left: 1.3, right: 1.3, top: 1, bottom: 1),
          controller: _tabController,
          splashBorderRadius: BorderRadius.circular(20),
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).primaryColor),
          labelStyle: Theme.of(context).textTheme.bodyText2,
          tabs: const [
            Tab(height: 40, child: CustomChip(label: ChipText(text: "Home"))),
            Tab(
                height: 40,
                child: CustomChip(label: ChipText(text: "बृज समाचार"))),
            Tab(height: 40, child: CustomChip(label: ChipText(text: "प्रदेश"))),
            Tab(height: 40, child: CustomChip(label: ChipText(text: "खेल"))),
            Tab(
                height: 40,
                child: CustomChip(label: ChipText(text: "देश-विदेश"))),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // Center(child: Text("होम पेज में आपका स्वागत है।")),
          HomeTab(),
          // Center(child: Text("बृज समाचार पेज में आपका स्वागत है।")),
          SecondaryTab(category: 3),
          // Center(child: Text("प्रदेश पेज में आपका स्वागत है।")),
          SecondaryTab(
            category: 4,
          ),
          // Center(child: Text("खेल पेज में आपका स्वागत है।")),
          SecondaryTab(
            category: 6,
          ),
          // Center(child: Text("देश-विदेश पेज में आपका स्वागत है।")),
          SecondaryTab(
            category: 5,
          ),
        ],
      ),
    );
  }
}
