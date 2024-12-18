import 'package:flutter/material.dart';
class MList extends StatelessWidget {
  final r;
  MList({required this.r});

  @override
  Widget build(BuildContext context) {


    return Card(
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        //decoration: BoxDecoration(color: sys.theme[900]),
        child: ListTile(
          //contentPadding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),

         leading: CircleAvatar(child: Text(r['title'][0])),
          trailing: Icon(Icons.more_vert),
          title: Text(
            r['title'],
            style: TextStyle(fontFamily: 'Raleway', fontSize: 13, fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: Text(r['subtitle1'], style: TextStyle(fontSize: 12, fontFamily: 'Raleway'))),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: Text(r['subtitle2'], style: TextStyle(fontSize: 12, fontFamily: 'Raleway'))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
