import 'package:adaptable_scaffold/adaptable_scaffold.dart';
import 'package:flutter/material.dart';

class WebBodyContentWidget extends StatelessWidget {
  const WebBodyContentWidget(
      {required this.navItem,
      this.overlayWidget,
      required this.maxWidth,
      required this.shouldShowAppStyleNav,
      this.headerBuilder,
      super.key});

  final NavigationItem navItem;
  final Widget? overlayWidget;
  final double maxWidth;
  final bool shouldShowAppStyleNav;
  final Widget Function(String)? headerBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      Widget page = navItem.page ?? Container();
      Widget column = ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            children: [
              _getHeader(),
              (navItem.shouldScroll) ? page : Expanded(child: page)
            ],
          ));
      Widget bodyBackground;
      if (navItem.shouldScroll) {
        bodyBackground = Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(child: column));
      } else {
        if (navItem.isFullScreen) {
          bodyBackground = Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: navItem.page ?? Container()));
        } else {
          bodyBackground = Align(alignment: Alignment.topCenter, child: column);
        }
      }
      return Stack(children: [
        bodyBackground,
        if (overlayWidget != null) overlayWidget!,
      ]);
    });
  }

  Widget _getHeader() {
    if (shouldShowAppStyleNav || navItem.title.isEmpty) {
      return const SizedBox.shrink();
    }
    if (headerBuilder == null) {
      return DefaultWebBodyPageHeader(navItem.title);
    } else {
      return headerBuilder!(navItem.title);
    }
  }
}

class DefaultWebBodyPageHeader extends StatelessWidget {
  const DefaultWebBodyPageHeader(this.title, {super.key});
  final String title;

  static double padding = 20;
  static double fontSize = 50;

  @override
  Widget build(BuildContext context) {
    if (title.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Text(
        title,
        style: TextStyle(
            fontSize: fontSize, color: Theme.of(context).primaryColor),
        textAlign: TextAlign.center,
      ),
    );
  }
}
