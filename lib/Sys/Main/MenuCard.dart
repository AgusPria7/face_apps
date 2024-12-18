import 'package:flutter/material.dart';
import 'package:face_apps/sys.dart';
void _doNothing(dynamic _) {}
class MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget page;
  final Function(dynamic) onClick;
  const MenuCard({
    required this.title,
    required this.icon,
    required this.page,
    this.onClick = _doNothing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 90,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                 onClick(1);
                Navigator.push(
                  context,
                  SlideRightRoute(
                    page: page,
                  ),
                );


              }, // handle your image tap here
              child: Icon(
                icon,
                size: 50,
                color: sys.theme,
              ),
            ),
            Text(
              title.toUpperCase(),
              style: TextStyle(
                color: sys.theme,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ));
  }
}

