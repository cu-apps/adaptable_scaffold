import 'package:adaptable_scaffold/adaptable_scaffold.dart';
import 'package:flutter/cupertino.dart';

class WebBodyContentWidget extends StatelessWidget {
  const WebBodyContentWidget(
      {required this.navItem,
      this.overlayWidget,
      required this.maxWidth,
      required this.shouldShowAppStyleNav,
      this.headerBuilder,
      Key? key})
      : super(key: key);

// TODO: Handle overlay widget
  final NavigationItem navItem;
  final Widget? overlayWidget;
  final double maxWidth;
  final bool shouldShowAppStyleNav;
  final Widget Function(String)? headerBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      var column = ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            children: [
              if (!shouldShowAppStyleNav)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                  child: (headerBuilder != null)
                      ? headerBuilder!(navItem.title)
                      : Text(navItem.title,
                          style: const TextStyle(fontSize: 50)),
                ),
              navItem.page ?? Container()
            ],
          ));
      if (navItem.shouldScroll) {
        return Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(child: column));
      } else {
        if (navItem.isFullScreen) {
          return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: navItem.page ?? Container()));
        } else {
          return Align(alignment: Alignment.topCenter, child: column);
        }
      }
    });
  }
}
