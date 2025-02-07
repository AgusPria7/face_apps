import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:face_apps/Sys/screens/setting_screen.dart';

import '../util/app_constants.dart';
import 'card_screen.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _isDarkMode;

  @override
  Widget build(BuildContext context) {
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          _backgroundAnimWidget(),
          _cardWidget(),
          _settings(),
        ],
      ),
    );
  }

  _backgroundAnimWidget() {
    return Center(
      child: FlareActor(Constants.background_anim,
          alignment: Alignment.center,
          fit: BoxFit.fill,
          animation: _isDarkMode
              ? Constants.night_animation
              : Constants.day_animation),
    );
  }

  _cardWidget() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.only(top: 70, left: 30, right: 30),
            child: CardWidgetScreen(),
          ),
        ),
        SizedBox(
          height: 150,
        ),
      ],
    );
  }

  _settings() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(
          icon: Icon(
            Icons.settings,
            color: Colors.pink,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingScreen()),
            );
          },
        ),
      ),
    );
  }
}
