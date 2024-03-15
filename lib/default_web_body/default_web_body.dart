import 'package:adaptable_scaffold/adaptable_scaffold.dart';
import 'package:adaptable_scaffold/web_body/web_body_content_widget.dart';
import 'package:flutter/material.dart';

class DefaultWebBody extends StatelessWidget {
  const DefaultWebBody(
      {required this.navItem,
      this.overlayWidget,
      required this.maxWidth,
      required this.shouldShowAppStyleNav,
      this.headerBuilder,
      required this.preferredWidth,
      super.key});

  final NavigationItem navItem;
  final Widget? overlayWidget;
  final double maxWidth;
  final bool shouldShowAppStyleNav;
  final Widget Function(String)? headerBuilder;
  final double preferredWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double largeViewWidth = preferredWidth * 1.2;
        if (constraints.maxWidth > largeViewWidth) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(flex: 1, child: Container()),
              Expanded(
                  flex: 2,
                  child: WebBodyContentWidget(
                    navItem: navItem,
                    overlayWidget: overlayWidget,
                    maxWidth: maxWidth,
                    shouldShowAppStyleNav: shouldShowAppStyleNav,
                    headerBuilder: headerBuilder,
                  )),
              Expanded(flex: 1, child: Container()),
            ],
          );
        } else {
          return WebBodyContentWidget(
            navItem: navItem,
            overlayWidget: overlayWidget,
            maxWidth: maxWidth,
            shouldShowAppStyleNav: shouldShowAppStyleNav,
            headerBuilder: headerBuilder,
          );
        }
      },
    );
  }
}
