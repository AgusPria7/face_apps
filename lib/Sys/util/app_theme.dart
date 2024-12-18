import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_color.dart';

class AppTheme {
  get darkTheme => ThemeData(
    primaryColor: Colors.black,
      backgroundColor: Colors.black,
      // useMaterial3: true,
      primarySwatch: Colors.grey,
      iconTheme: IconThemeData(
        color: Colors.white
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.white),
      appBarTheme:
          AppBarTheme(color: AppColors.textBlack, systemOverlayStyle: SystemUiOverlayStyle.light),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: AppColors.textGrey),
        labelStyle: TextStyle(color: AppColors.white),
      ),
      brightness: Brightness.dark,
      fontFamily: 'Ubuntu',
      canvasColor: Colors.black,
      // canvasColor: Colors.black,
      hintColor: AppColors.white,
      cardTheme: CardTheme(color: Colors.black, elevation: 2),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
      ),
      dividerColor: Colors.white,
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: TextStyle(color: Colors.white),
      ), bottomAppBarTheme: BottomAppBarTheme(color: Colors.black));

  get lightTheme => ThemeData(
    primaryColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: AppColors.white, systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: AppColors.textGrey),
          labelStyle: TextStyle(color: AppColors.white),
        ),
        fontFamily: 'Ubuntu',
    iconTheme: IconThemeData(
        color: Colors.black
    ),
        canvasColor: AppColors.white,
        dividerTheme: DividerThemeData(color: Colors.grey, thickness: 1),
        indicatorColor: Colors.blue,
        progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.blue),
        brightness: Brightness.light,
        hintColor: AppColors.grey2,
        actionIconTheme: ActionIconThemeData(),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
        ),
        bottomAppBarColor: Colors.white,
        dividerColor: Colors.grey,
        cardTheme: CardTheme(color: Colors.white, elevation: 2),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
            .copyWith(background: Colors.white),
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: TextStyle(color: Colors.black),
        ),
      );
}
