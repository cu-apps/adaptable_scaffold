library;

import 'dart:math';

import 'package:adaptable_scaffold/default_app_bars/default_app_style_bar.dart';
import 'package:adaptable_scaffold/default_app_bars/default_web_bar_button.dart';
import 'package:adaptable_scaffold/default_app_bars/default_web_style_bar.dart';
import 'package:adaptable_scaffold/default_web_body/default_web_body.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class AdaptableScaffold extends StatefulWidget {
  const AdaptableScaffold(
      {this.pageIndex = 0,
      this.onNavigationItemPressed,
      this.navigationItems = const [],
      this.bodyNavItem,
      this.showNavOnlyOnWeb = false,
      this.preferredWidth = 500,
      this.maxContentWidth = 600,
      this.webButtonWidth = 180,
      this.largeViewWidthThreshold = 800,
      this.appBarTitleActions,
      this.webBodyLayoutBuilder,
      required this.tabBarMoreBuilder,
      this.webHeadingBuilder,
      this.webButtonBuilder,
      this.maxAppTabsVisible = 5,
      this.appBarBuilder,
      this.webBarBuilder,
      this.overlayWidget,
      super.key});

  final int pageIndex;
  final Function(int)? onNavigationItemPressed;
  final List<NavigationItem> navigationItems;
  final NavigationItem? bodyNavItem;
  final bool showNavOnlyOnWeb;
  final double preferredWidth;
  final double maxContentWidth;
  final double webButtonWidth;
  final double largeViewWidthThreshold;
  final List<Widget>? appBarTitleActions;

  // All navigation items, how many nav items are shown in standard view already, hideTabBarCallback, onNavigationItemPressed
  final Widget Function(List<NavigationItem>, int, Function, Function(int)?)
      tabBarMoreBuilder;
  final Widget Function(String)? webHeadingBuilder;
  // title, width
  final Widget Function(String, double)? webButtonBuilder;

  // navItem, overlayWidget, context, constraints, preferredWidth, headerBuilder, maxWidth, shouldShowAppStyleNav
  final Widget Function(
      NavigationItem navItem,
      Widget? overlayWidget,
      BuildContext context,
      BoxConstraints constraints,
      double preferredWidth,
      Widget Function(String) headerBuilder,
      double maxWidth,
      bool shouldShowAppStyleNav)? webBodyLayoutBuilder;
  final int maxAppTabsVisible;
  final Widget? overlayWidget;

  // title, actions, leadingWidget
  final PreferredSizeWidget? Function(String, List<Widget>?, Widget?)?
      appBarBuilder;

  // title, actions, leadingWidget, navItems, navItemPressed, moreTabItemPressed, numberOfVisibleTabsChanged, buttonWidth, buttonBuilder
  final PreferredSizeWidget Function(
      String,
      List<Widget>?,
      Widget?,
      List<NavigationItem>,
      Function(int)?,
      Function,
      Function(int)?,
      double,
      Widget Function(String, double))? webBarBuilder;

  @override
  State<AdaptableScaffold> createState() => _AdaptableScaffoldState();
}

class _AdaptableScaffoldState extends State<AdaptableScaffold> {
  bool _shouldShowMorePage = false;
  int _numberOfTabsVisible = 0;

  void _setNumberOfTabs(int numOfTabs) {
    _numberOfTabsVisible = numOfTabs;
  }

  NavigationItem get currentNavigationItem {
    if (widget.bodyNavItem != null) {
      return widget.bodyNavItem!;
    } else {
      return (_shouldShowMorePage)
          ? NavigationItem(
              icon: const Icon(Icons.more_horiz),
              label: "More",
              title: "More",
              page: widget.tabBarMoreBuilder(
                  widget.navigationItems, _numberOfTabsVisible, () {
                setState(() {
                  _shouldShowMorePage = false;
                });
              }, widget.onNavigationItemPressed))
          : widget.navigationItems[widget.pageIndex];
    }
  }

  int _getNumberOfAppTabsVisible() {
    if (widget.navigationItems.length > widget.maxAppTabsVisible) {
      return widget.maxAppTabsVisible - 1;
    } else {
      return min(widget.maxAppTabsVisible, widget.navigationItems.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      var shouldShowAppStyleNav =
          _getShouldShowAppStyleNav(maxWidth: constraints.maxWidth);
      if (shouldShowAppStyleNav) {
        _numberOfTabsVisible = _getNumberOfAppTabsVisible();
      }
      return Scaffold(
        appBar: _getAppBar(
            shouldShowAppStyleNav: shouldShowAppStyleNav,
            navItems: widget.navigationItems,
            context: context),
        body: _getBody(shouldShowAppStyleNav, context, constraints),
        bottomNavigationBar: (shouldShowAppStyleNav &&
                !widget.showNavOnlyOnWeb &&
                widget.navigationItems.length > 1)
            ? BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: (_shouldShowMorePage)
                    ? widget.maxAppTabsVisible - 1
                    : min(widget.pageIndex, widget.maxAppTabsVisible - 1),
                selectedItemColor: Theme.of(context).primaryColor,
                items: _getBottomNavigationBarItems(),
                onTap: (index) {
                  if (_getBottomNavigationBarItems()[index].label == "More") {
                    setState(() {
                      _shouldShowMorePage = true;
                    });
                  } else {
                    setState(() {
                      _shouldShowMorePage = false;
                    });
                    widget.onNavigationItemPressed?.call(index);
                    if (widget.navigationItems[index].page != null) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                  }
                })
            : null,
      );
    });
  }

  List<NavigationItem> _getTabBarNavItems() {
    if (widget.navigationItems.length <= widget.maxAppTabsVisible) {
      return widget.navigationItems;
    } else {
      var listItems =
          widget.navigationItems.sublist(0, widget.maxAppTabsVisible - 1);
      listItems.add(NavigationItem(
          icon: const Icon(Icons.more_horiz),
          label: 'More',
          title: 'More',
          badgeCounter: widget.navigationItems
              .sublist(widget.maxAppTabsVisible)
              .fold(0,
                  (sum, element) => (sum ?? 0) + (element.badgeCounter ?? 0))));
      return listItems;
    }
  }

  List<BottomNavigationBarItem> _getBottomNavigationBarItems() {
    return _getTabBarNavItems()
        .map((e) => BottomNavigationBarItem(
            icon: e.badgeCounter != null && e.badgeCounter != 0
                ? Badge.count(count: e.badgeCounter!, child: e.icon)
                : e.icon!,
            label: e.label))
        .toList();
  }

  Widget _getBody(bool shouldShowAppStyleNav, BuildContext context,
      BoxConstraints constraints) {
    return shouldShowAppStyleNav
        ? _getAppBody(context)
        : _getWebBody(context, shouldShowAppStyleNav, constraints);
  }

  Widget _getAppBody(BuildContext context) {
    Widget bodyWithKeyboardDismissal = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: currentNavigationItem.page ?? Container(),
    );

    if (currentNavigationItem.shouldScroll) {
      return _getBodyWithOverlay(Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(child: bodyWithKeyboardDismissal)));
    } else {
      return _getBodyWithOverlay(bodyWithKeyboardDismissal);
    }
  }

  Widget _getBodyWithOverlay(Widget body) {
    return (widget.overlayWidget == null)
        ? body
        : Stack(children: [body, widget.overlayWidget!]);
  }

  Widget _getWebBody(BuildContext context, bool shouldShowAppStyleNav,
      BoxConstraints constraints) {
    return (widget.webBodyLayoutBuilder == null)
        ? DefaultWebBody(
            navItem: currentNavigationItem,
            overlayWidget: widget.overlayWidget,
            maxWidth: widget.maxContentWidth,
            shouldShowAppStyleNav: shouldShowAppStyleNav,
            headerBuilder: widget.webHeadingBuilder,
            preferredWidth: widget.preferredWidth)
        : widget.webBodyLayoutBuilder!(
            currentNavigationItem,
            widget.overlayWidget,
            context,
            constraints,
            widget.preferredWidth,
            widget.webHeadingBuilder ??
                (title) => Text(title, style: const TextStyle(fontSize: 50)),
            widget.maxContentWidth,
            shouldShowAppStyleNav);
  }

  PreferredSizeWidget? _getAppBar(
      {required bool shouldShowAppStyleNav,
      required List<NavigationItem> navItems,
      required BuildContext context}) {
    if (shouldShowAppStyleNav) {
      if (currentNavigationItem.isFullScreen) {
        return null;
      } else {
        return (widget.appBarBuilder == null)
            ? DefaultAppStyleBar(
                title: currentNavigationItem.title,
                actions: (currentNavigationItem.appBarTitleActions ?? []) +
                    (widget.appBarTitleActions ?? []),
                leadingWidget: currentNavigationItem.appBarLeadingWidget)
            : widget.appBarBuilder!(
                currentNavigationItem.title,
                (currentNavigationItem.appBarTitleActions ?? []) +
                    (widget.appBarTitleActions ?? []),
                currentNavigationItem.appBarLeadingWidget,
              );
      }
    } else {
      if (navItems.length < 2) {
        return null;
      }
      return (widget.webBarBuilder == null)
          ? DefaultWebStyleBar(
              title: currentNavigationItem.title,
              actions: (currentNavigationItem.appBarTitleActions ?? []) +
                  (widget.appBarTitleActions ?? []),
              buttonWidth: widget.webButtonWidth,
              navigationItems: navItems,
              onTabBarItemTapped: (index) {
                setState(() {
                  _shouldShowMorePage = false;
                });
                widget.onNavigationItemPressed?.call(index);
                if (widget.navigationItems[index].page != null) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
              },
              numberOfVisibleTabBarsChanged: _setNumberOfTabs,
              moreTabItemPressed: _showMorePage,
            )
          : widget.webBarBuilder!(
              currentNavigationItem.title,
              (currentNavigationItem.appBarTitleActions ?? []) +
                  (widget.appBarTitleActions ?? []),
              currentNavigationItem.appBarLeadingWidget,
              navItems,
              widget.onNavigationItemPressed,
              _showMorePage,
              _setNumberOfTabs,
              widget.webButtonWidth,
              widget.webButtonBuilder ??
                  (title, buttonWidth) => DefaultWebBarButton(
                        padding: const EdgeInsets.all(10),
                        fixedWidth: buttonWidth,
                        title: title,
                        textColor: Colors.grey[800],
                        hoverColor:
                            Theme.of(context).primaryColor.withAlpha(25),
                      ));
    }
  }

  void _showMorePage() {
    setState(() {
      _shouldShowMorePage = true;
    });
  }

  bool _getShouldShowAppStyleNav({required double maxWidth}) {
    return !kIsWeb || maxWidth < widget.largeViewWidthThreshold;
  }
}

class NavigationItem {
  NavigationItem(
      {this.icon,
      this.label,
      required this.title,
      this.page,
      this.urlToOpen,
      this.shouldScroll = true,
      this.isFullScreen = false,
      this.badgeCounter,
      this.appBarTitleActions,
      this.appBarLeadingWidget});
  final Icon? icon;
  final String? label;
  final String title;
  final Widget? page;
  final String? urlToOpen;
  final bool shouldScroll;
  final bool isFullScreen;
  final int? badgeCounter;
  final List<Widget>? appBarTitleActions;
  final Widget? appBarLeadingWidget;
}
