import 'package:adaptable_scaffold/adaptable_scaffold.dart';
import 'package:example/custom_web_body.dart';
import 'package:example/styled_app_bar.dart';
import 'package:example/tab_bar_more_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AdaptableScaffold(
        pageIndex: pageIndex,
        navigationItems: [
          NavigationItem(
              icon: const Icon(Icons.access_alarm_outlined),
              label: "Alarm",
              title: "Alarm",
              badgeCounter: 3,
              page: const LongPage(Colors.green)),
          NavigationItem(
              icon: const Icon(Icons.stop_circle),
              label: "Stopwatch",
              title: "Stopwatch",
              page: const LongPage(Colors.blue)),
          NavigationItem(
              icon: const Icon(Icons.directions_walk),
              label: "Steps",
              title: "Steps",
              page: const ShortPage(Colors.red)),
          NavigationItem(
              icon: const Icon(Icons.directions_walk),
              label: "Steps 2",
              title: "Steps 2",
              page: const ShortPage(Colors.yellow),
              isFullScreen: true),
          NavigationItem(
              icon: const Icon(Icons.access_alarm_outlined),
              label: "Alarm",
              title: "Alarm",
              badgeCounter: 3,
              page: const LongPage(Colors.green)),
          NavigationItem(
              icon: const Icon(Icons.stop_circle),
              label: "Stopwatch",
              title: "Stopwatch",
              badgeCounter: 3,
              page: const LongPage(Colors.blue)),
          NavigationItem(
              icon: const Icon(Icons.directions_walk),
              label: "Steps",
              title: "Steps",
              page: const ShortPage(Colors.red)),
          NavigationItem(
              icon: const Icon(Icons.directions_walk),
              label: "Steps 2",
              title: "Steps 2",
              badgeCounter: 2,
              page: const ShortPage(Colors.yellow),
              isFullScreen: true)
        ],
        appBarBuilder: (title, actions, leadingWidget) => StyledAppBar(
              title: title,
              actions: actions ?? [],
              leadingWidget: leadingWidget,
            ),
        onNavigationItemPressed: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        maxAppTabsVisible: 3,
        maxContentWidth: 800,
        webBodyLayoutBuilder: (navItem,
                overlayWidget,
                context,
                constraints,
                preferredWidth,
                Widget Function(String)? headerBuilder,
                maxWidth,
                shouldShowAppStyleNav) =>
            CustomWebBody(
                navItem: navItem,
                overlayWidget: overlayWidget,
                maxWidth: maxWidth,
                shouldShowAppStyleNav: shouldShowAppStyleNav,
                preferredWidth: preferredWidth,
                headerBuilder: headerBuilder),
        tabBarMoreBuilder: (navItems, numberOfTabsVisible, hideTabBar,
                onNavigationItemPressed) =>
            TabBarMorePage(navItems, numberOfTabsVisible,
                onNavigationItemPressed, hideTabBar));
  }
}

class LongPage extends StatelessWidget {
  const LongPage(this.color, {super.key});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [for (var i = 0; i < 100; i += 1) i]
                .map((e) => SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Card(
                            color: color,
                            child: ListTile(
                              title: Text("Random title ${e + 1}",
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white)),
                              subtitle: Text("Random content ${e + 1}",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white)),
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (e % 3 == 0)
                                    const Icon(
                                      Icons.label,
                                      color: Colors.white,
                                    ),
                                  if (e % 3 == 1)
                                    const Icon(
                                      Icons.map,
                                      color: Colors.white,
                                    ),
                                  if (e % 3 == 2)
                                    const Icon(
                                      Icons.create_outlined,
                                      color: Colors.white,
                                    )
                                ],
                              ),
                              trailing: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ))
                .toList()));
  }
}

class ShortPage extends StatelessWidget {
  const ShortPage(this.color, {super.key});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [for (var i = 0; i < 10; i += 1) i]
                .map((e) => SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Card(
                            color: color,
                            child: ListTile(
                              title: Text("Random title ${e + 1}",
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white)),
                              subtitle: Text("Random content ${e + 1}",
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.white)),
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (e % 3 == 0)
                                    const Icon(
                                      Icons.label,
                                      color: Colors.white,
                                    ),
                                  if (e % 3 == 1)
                                    const Icon(
                                      Icons.map,
                                      color: Colors.white,
                                    ),
                                  if (e % 3 == 2)
                                    const Icon(
                                      Icons.create_outlined,
                                      color: Colors.white,
                                    )
                                ],
                              ),
                              trailing: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ))
                .toList()));
  }
}
