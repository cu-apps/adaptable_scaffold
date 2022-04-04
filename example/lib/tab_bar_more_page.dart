import 'package:adaptable_scaffold/adaptable_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class TabBarMorePage extends StatelessWidget {
  const TabBarMorePage(this.navigationItems, this.numberOfTabsVisible, this.onNavigationItemPressed, this.hideTabBar);
  final List<NavigationItem> navigationItems;
  final int numberOfTabsVisible;
  final Function(int)? onNavigationItemPressed;
  final Function hideTabBar;

  Widget getMenuItem(Icon leadingIcon, String title, Widget? pageToNavigateTo,
      bool bodyShouldScroll, BuildContext context, int index) {
    return Card(
      child: ListTile(
        leading: Icon(leadingIcon.icon),
        title: Text(title),
        onTap: () {
          if (onNavigationItemPressed != null) {
            hideTabBar();
            onNavigationItemPressed!(index);
          }

          // if (urlToOpen != null) {
          //   // launch(urlToOpen, forceSafariVC: false);
          // } else if (action != null) {
          //   action.call();
          // } else if (pageToNavigateTo != null) {
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => routeDestinationBuilder(
          //               pageToNavigateTo, null)));
          // }
        },
      ),
    );
    // return MenuItem(
    //     leadingIcon: leadingIcon.icon,
    //     title: title,
    //     onPressed: () {
    //       if (urlToOpen != null) {
    //         // launch(urlToOpen, forceSafariVC: false);
    //       } else if (action != null) {
    //         action.call();
    //       } else if (pageToNavigateTo != null) {
    //         Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //                 builder: (context) => routeDestinationBuilder(
    //                     pageToNavigateTo, null)));
    //       }
    //     },
    //     badgeCount: badgeCount
    // );
  }

  List<NavigationItem> get navItemsToShow => navigationItems.sublist(numberOfTabsVisible);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
            children: navItemsToShow
                .mapIndexed((index, element) => getMenuItem(
                element.icon, element.label, element.page, element.shouldScroll, context, index + numberOfTabsVisible))
                .toList()),
      ),
    );
  }
}
