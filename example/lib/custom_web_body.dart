import 'package:adaptable_scaffold/adaptable_scaffold.dart';
import 'package:adaptable_scaffold/web_body/web_body_content_widget.dart';
import 'package:flutter/material.dart';

class CustomWebBody extends StatelessWidget {
  const CustomWebBody(
      {required this.navItem,
      this.overlayWidget,
      required this.maxWidth,
      required this.shouldShowAppStyleNav,
      this.headerBuilder,
      required this.preferredWidth,
      Key? key})
      : super(key: key);

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
          return Container(
            color: Colors.blue,
            child: Stack(children: [
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                      child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Card(
                      elevation: 20,
                      child: WebBodyContentWidget(
                        navItem: navItem,
                        overlayWidget: overlayWidget,
                        maxWidth: maxWidth,
                        shouldShowAppStyleNav: shouldShowAppStyleNav,
                        headerBuilder: headerBuilder,
                      ),
                    ),
                  )))
            ]),
          );
          // return Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Expanded(
          //       flex: 1,
          //       child: Container(
          //         color: Theme.of(context).primaryColor,
          //       ),
          //     ),
          //     Expanded(
          //         flex: 2,
          //         child: WebBodyContentWidget(
          //           navItem: navItem,
          //           overlayWidget: overlayWidget,
          //           maxWidth: maxWidth,
          //           shouldShowAppStyleNav: shouldShowAppStyleNav,
          //           headerBuilder: headerBuilder,
          //         )),
          //     Expanded(
          //       flex: 1,
          //       child: Container(
          //         color: Theme.of(context).primaryColor,
          //       ),
          //     ),
          //   ],
          // );
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
