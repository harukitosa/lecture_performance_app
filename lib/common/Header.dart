import 'package:flutter/material.dart';

//------------------------ Header ------------------------
//共通のHeaderです。指定されたTitleの文字を表示します。
class Header extends StatelessWidget with PreferredSizeWidget {
  // constructor
  Header({Key key, @required this.title, this.onTap, this.actionIcon})
      : assert(title != null),
        super(key: key);

  final String title;
  // final Function() onTap;
  final void Function() onTap;
  final Icon actionIcon;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue,
      actions: [
        // ignore: sdk_version_ui_as_code
        if (actionIcon != null)
          Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              icon: actionIcon,
              onPressed: onTap,
            ),
          ),
      ],
      title: Text(title),
    );
  }
}
