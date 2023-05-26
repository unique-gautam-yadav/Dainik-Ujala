import 'dart:developer';
import 'dart:ui';

import 'package:dainik_ujala/Backend/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
    required this.data,
    required this.bri,
  });
  final NewsArtical data;
  final Brightness bri;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  String css = """
<style> 
@keyframes universe {
  0% {
    transform: rotate(0deg) scale(var(--scale)); }
  100% {
    transform: rotate(-360deg) scale(var(--scale)); } }

.universe, .universe > div {
  --scale: 1;
  height: 100px;
  width: 100px;
  position: relative;
  animation: linear universe 9s infinite; }
  .universe:before, .universe > div:before {
    content: '';
    display: block;
    height: 100px;
    width: 50px;
    background: transparent;
    border-radius: 50px 0 0 50px;
    border: none;
    border-bottom: 5px solid var(--primary);
    border-left: 2px solid var(--primary);
    border-top: 0 solid var(--primary);
    opacity: 0.3; }
  .universe:after, .universe > div:after {
    content: '';
    position: absolute;
    display: block;
    top: 38px;
    left: 38px;
    height: 24px;
    width: 24px;
    background: var(--primary);
    border-radius: 16.66667px; }

.universe > div:nth-child(1) {
  position: absolute;
  top: 25px;
  left: 25px;
  width: 50px;
  height: 50px;
  animation: linear universe 7s infinite; }
  .universe > div:nth-child(1):before {
    height: 50px;
    width: 25px;
    border-bottom: 4px solid var(--primary);
    border-left: 2px solid var(--primary); }
  .universe > div:nth-child(1):after {
    top: 44px;
    left: 22px;
    width: 8.33333px;
    height: 8.33333px;
    background: var(--secondary); }

.universe > div:nth-child(2) {
  --scale: .333;
  top: -52.5%; }
  .universe > div:nth-child(2):before {
    border-bottom: 12.5px solid var(--primary);
    border-left: 3.33333px solid var(--primary); }
  .universe > div:nth-child(2):after {
    top: 29px;
    left: 29px;
    width: 42px;
    height: 42px;
    border-radius: 29px;
    background: var(--secondary); }
  .universe > div:nth-child(2) > div {
    position: absolute;
    background: var(--secondary);
    width: 20px;
    height: 20px;
    bottom: -5.55556px;
    left: 40px;
    border-radius: 10px; 
  }

  #loading{
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
  }

</style>
""";

  _handleShare(String url, String title) async {
    log("askd");
    final box = context.findRenderObject() as RenderBox?;
    try {
      await Share.share(url,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
      log("Done");
    } catch (e) {
      log(e.toString());
    }
    log("bbasdk");
  }

  Future<bool> _handleUrlTap(String u) async {
    Uri url = Uri.parse(u);

    return await launchUrl(url);
  }

  late WebViewController controller;

  late AnimationController bannerController;
  late Animation<double> blur;
  late Animation<double> position;

  bool hasBanner = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      precacheImage(const AssetImage("assets/images/logo.png"), context);
    });

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            _handleUrlTap(request.url);
            return NavigationDecision.prevent;
          },
        ),
      )
      ..setBackgroundColor(const Color(0x00000000))
      ..loadHtmlString("""
                  <body>
                    <div id="loading">
                      <div>
                        <div class="universe">
                          <div>
                            <div></div>
                          </div>
                          <div>
                            <div></div>
                          </div>
                        </div>
                        <br/>
                        Loading...
                      </div>
                    </div>
                    
                    <img src="${widget.data.urlToImage}" width="100%">
                    <br/> 
                    <div class="cont">
                      <p class="title">
                          ${widget.data.title}
                      </p>
                      <hr/>
                        ${widget.data.content}
                    </div>
                    <br/><br/><br/><br/>
                  </body>

                  $css

      <style>

        .cont img{
          width: calc(100% - 50px);
          padding: 25px;
          object-fit: scale-down;
        }

        body {
          font-size: 38px; 
          color: 
          ${widget.bri == Brightness.light ? "black" : "white"};
        } 
        
        :root{
            --primary: #881e43;
            --secondary: #881e43;
        }

        .cont{
            text-align: justify;
            padding-left: 35px;
            padding-right: 35px;
        }

        .title{
          font-size : 48px;
          font-weight : bold;
          text-align: justify;
        }

      </style>


    <script>
      document.onreadystatechange = function() {
          if (document.readyState !== "complete") {
              document.querySelector("body").style.visibility = "hidden";
              document.querySelector("#loading").style.visibility = "visible";
          } else {
            setTimeout(() => {
              document.querySelector("#loading").style.display = "none";
              document.querySelector("body").style.visibility = "visible";
            }, 2000);
          }
      };
    </script>
""");

    bannerController = AnimationController(
        duration: const Duration(milliseconds: 150), vsync: this);

    blur = Tween<double>(begin: 0, end: 6).animate(bannerController)
      ..addListener(() {
        setState(() {});
      });

    position = Tween<double>(begin: -300, end: 0).animate(bannerController)
      ..addListener(() {
        setState(() {});
      });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 5)).then((value) {
        precacheImage(const AssetImage("assets/images/advt.jpeg"), context)
            .whenComplete(() {
          setState(() {
            hasBanner = true;
          });
          bannerController.forward();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Scaffold(
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
                height: (Theme.of(context).textTheme.bodyLarge?.fontSize ?? 0) *
                    1.5,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: HtmlWidget(
                    widget.data.title,
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
            body: Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        opacity: .25,
                        image: AssetImage("assets/images/logo.png"),
                      ),
                    ),
                    child: SizedBox(
                      child: WebViewWidget(
                        controller: controller,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            offset: const Offset(3, 0),
                            blurRadius: 10,
                          ),
                          BoxShadow(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            offset: const Offset(0, 3),
                            blurRadius: 10,
                          ),
                          BoxShadow(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            offset: const Offset(-3, 0),
                            blurRadius: 10,
                          ),
                          BoxShadow(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            offset: const Offset(0, -3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
                            left: 8,
                            right: 12,
                          ),
                          child: Text(DateFormat.jm()
                              .addPattern('; d MMMM y (EEEE)')
                              .format(
                                  DateTime.parse(widget.data.publishedAt))))),
                ),
              ],
            ),
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
          hasBanner
              ? Positioned(
                  right: 30,
                  bottom: 30,
                  child: Transform.translate(
                    offset: Offset(position.value, 0),
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).dialogBackgroundColor,
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Flexible(
                          child: SizedBox(
                            height: 250,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              child: Image.asset(
                                "assets/images/advt.jpeg",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: double.infinity,
                          width: .5,
                          color: Theme.of(context).dividerColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2),
                          child: SizedBox(
                            width: 41,
                            height: 246,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton.filledTonal(
                                  onPressed: () {
                                    bannerController
                                        .reverse()
                                        .whenCompleteOrCancel(
                                      () {
                                        setState(() {
                                          hasBanner = false;
                                        });
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.close_rounded),
                                ),
                                const Expanded(
                                  child: RotatedBox(
                                    quarterTurns: 1,
                                    child: Center(
                                      child: Text(
                                        "Advertisement",
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ]),
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
