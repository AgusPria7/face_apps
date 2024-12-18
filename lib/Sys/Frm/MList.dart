import 'package:flutter/material.dart';
import 'package:face_apps/sys.dart';

class MList extends StatelessWidget {
  final r;
  MList({required this.r});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      color: Colors.white,
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(3)),
              child: Container(
                width: 7,
                height: 100,
                color: Colors.deepOrange,
              )),
          Container(
            width: 70,
            height: 100,
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(color: Colors.deepOrange[100], border: Border.all(color: Colors.deepOrange[100]!)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '22-29',
                    style: TextStyle(fontSize: 18, color: Colors.deepOrange, fontWeight: FontWeight.bold),
                  ),
                  new Text(
                    'Jul',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  r['title'],
                  style: TextStyle(fontSize: 17, color: sys.theme[800], fontWeight: FontWeight.bold),
                ),
                Icon(Icons.more_vert),
              ]),
              Divider(
                endIndent: 30,
                color: sys.theme[800],
              ),
              Text(
                r['subtitle1'],
                style: TextStyle(
                  fontSize: 14.0,
                  color: sys.theme[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       r['subtitle2'],
              //       style: TextStyle(
              //         fontSize: 12.0,
              //         fontWeight: FontWeight.normal,
              //       ),
              //     ),
              //     // Padding(
              //     //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //     //   child: Icon(Icons.data_usage),
              //     // ),
              //   ],
              // ),
            ],
          )),
        ],
      ),
    );
  }
}
