import 'package:flutter/material.dart';

class StyledAppBar extends StatelessWidget implements PreferredSizeWidget {
  StyledAppBar({this.title, this.actions = const [], this.leadingWidget = null});
  final String? title;
  final List<Widget> actions;
  final Widget? leadingWidget;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(
            color: Colors.white
        ),
        actionsIconTheme: const IconThemeData(
            color: Colors.white
        ),
        centerTitle: true,
        title: (title != null) ? Text(title!,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center) : null,
        actions: actions,
        leading: leadingWidget);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
