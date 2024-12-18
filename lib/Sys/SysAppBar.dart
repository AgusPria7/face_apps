import 'package:flutter/material.dart';
import 'package:face_apps/sys.dart';
class SysAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  SysAppBar({required this.title,this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: sys.theme[900],
      elevation: 0.0,
      bottomOpacity: 0.0,
      title: Text(
        title,
        style: TextStyle(color:Colors.white),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
