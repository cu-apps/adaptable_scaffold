import 'dart:math';

import 'package:adaptable_scaffold/adaptable_scaffold.dart';
import 'package:adaptable_scaffold/default_app_bars/default_web_bar_button.dart';
import 'package:flutter/material.dart';

class DefaultWebStyleBar extends StatefulWidget implements PreferredSizeWidget {
  const DefaultWebStyleBar(
      {this.title,
      this.actions = const [],
      this.navigationItems = const [],
      required this.onTabBarItemTapped,
      required this.moreTabItemPressed,
      required this.numberOfVisibleTabBarsChanged,
      this.buttonWidth = 180,
      this.buttonBuilder,
      super.key});
  final String? title;
  final List<Widget> actions;
  final List<NavigationItem> navigationItems;
  final ValueChanged<int> onTabBarItemTapped;
  final ValueChanged<int> numberOfVisibleTabBarsChanged;
  final Function moreTabItemPressed;
  final double buttonWidth;
  final Widget Function(String, double)? buttonBuilder;

  @override
  State<DefaultWebStyleBar> createState() => _DefaultWebStyleBarState();

  @override
  Size get preferredSize => const Size.fromHeight(72);
}

class _DefaultWebStyleBarState extends State<DefaultWebStyleBar> {
  int _numberOfVisibleTabBars = 0;

  _menuButtonPressed(String title) {
    widget.onTabBarItemTapped(
        widget.navigationItems.indexWhere((element) => element.title == title));
  }

  List<Widget> _getMenuButtons(
      List<NavigationItem> navItems, BuildContext context) {
    return navItems
        .map((element) => ((widget.buttonBuilder == null)
            ? DefaultWebBarButton(
                padding: const EdgeInsets.all(10),
                title: element.title,
                onPressed: () {
                  if (element.label == "More") {
                    widget.moreTabItemPressed();
                  } else {
                    _menuButtonPressed(element.title);
                  }
                },
                textColor: Colors.grey[800],
                hoverColor: Theme.of(context).primaryColor.withAlpha(25),
                fixedWidth: widget.buttonWidth,
              )
            : GestureDetector(
                child: widget.buttonBuilder!(element.title, widget.buttonWidth),
                onTap: () {
                  if (element.label == "More") {
                    widget.moreTabItemPressed();
                  } else {
                    _menuButtonPressed(element.title);
                  }
                },
              )))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: getWebBarButtons(widget.navigationItems, context))),
          ],
        ),
        actions: widget.actions);
  }

  int _getNumberOfVisibleTabBars(int noOfButtons, int noOfNavItems) {
    int noOfVisibleTabBars;
    if (noOfButtons < noOfNavItems) {
      noOfVisibleTabBars = noOfButtons - 1;
    } else {
      noOfVisibleTabBars = noOfButtons;
    }
    noOfVisibleTabBars = min(noOfVisibleTabBars, noOfNavItems);
    return noOfVisibleTabBars;
  }

  Widget getWebBarButtons(
      List<NavigationItem> navigationItems, BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      int numberOfButtons = (constraints.maxWidth ~/ widget.buttonWidth);
      int newNumberOfVisibleTabBarsChanged =
          _getNumberOfVisibleTabBars(numberOfButtons, navigationItems.length);
      if (newNumberOfVisibleTabBarsChanged != _numberOfVisibleTabBars) {
        _numberOfVisibleTabBars = newNumberOfVisibleTabBarsChanged;
        widget.numberOfVisibleTabBarsChanged(_numberOfVisibleTabBars);
      }
      List<NavigationItem> navItemsToShow = [];
      if (numberOfButtons < navigationItems.length) {
        navItemsToShow = navigationItems.sublist(0, numberOfButtons - 1);
        navItemsToShow.add(NavigationItem(
            icon: const Icon(Icons.more_horiz),
            label: "More",
            title: "More",
            page: Container()));
      } else {
        navItemsToShow = navigationItems;
      }
      return Row(
          mainAxisSize: MainAxisSize.min,
          children: _getMenuButtons(navItemsToShow, context));
    });
  }
}
