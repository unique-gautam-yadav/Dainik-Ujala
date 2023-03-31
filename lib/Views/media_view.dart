import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:zoom_widget/zoom_widget.dart';

import '../UI Components/compnents.dart';

class MediaView extends StatelessWidget {
  const MediaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Skelaton(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.only(top: 80),
      child: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return MediaItem();
        },
      ),
    )));
  }
}

class MediaItem extends StatefulWidget {
  const MediaItem({
    super.key,
  });

  @override
  State<MediaItem> createState() => _MediaItemState();
}

class _MediaItemState extends State<MediaItem> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    return Styled.widget(
      child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).textTheme.bodyLarge!.color!)),
          child: const FlutterLogo()),
    )
        .ripple()
        .padding(all: 2)
        .gestures(onTap: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const PopUpView(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ));
        }, onTapChange: (tapState) {
          setState(() {
            pressed = tapState;
          });
        })
        .scale(all: pressed ? 0.95 : 1, animate: true)
        .animate(const Duration(milliseconds: 150), Curves.easeOut);
  }
}

class PopUpView extends StatelessWidget {
  const PopUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey.shade900,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 55,
                color: Colors.black.withOpacity(0.2),
                child: ButtonBar(
                    alignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.download_rounded,
                            color: Colors.white,
                          ))
                    ]),
              ),
              Expanded(
                child: Zoom(
                    initTotalZoomOut: true,
                    backgroundColor: Colors.transparent,
                    child: const FlutterLogo(
                      size: 1000,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
