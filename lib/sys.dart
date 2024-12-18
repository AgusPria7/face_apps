import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class sys {
  static String version = "0.0.3";
  // static String SITE_URL = "https://apx.gea-rsa.com/aprv/apx.php/want2SRAMX0/";
  // static String BASE_URL = "https://apx.gea-rsa.com/aprv/";
  static const String SITE_KEY = 'ooTqewNQ1FkBex9l4nN8z0iLYvllOyrBxIMMIxHkGFkh6h7xDv1rrxbeySmbMzawjssiun';

  static String BASE_URL = "http://172.25.4.76/MRP/";
  static String SITE_URL = "http://172.25.4.76/MRP/xmx/";

  // static String BASE_URL = "http://192.168.55.213/MRP/";
  // static String SITE_URL = "http://192.168.55.213/MRP/xmx/";

  // static String BASE_URL = "http://172.25.4.118/mrp/";
  // static String SITE_URL = "http://172.25.4.118/mrp/xmx/";

  // static String BASE_URL = "http://172.25.4.66/RSA/";
  // static String SITE_URL = "http://172.25.4.66/RSA/xmx/";

  // static String BASE_URL = "http://172.25.9.180/RSA/";
  // static String SITE_URL = "http://172.25.9.180/RSA/xmx/";

  // static String BASE_URL = "http://192.168.43.196/RSA/";
  // static String SITE_URL = "http://192.168.43.196/RSA/xmx/";

  // static String BASE_URL = "http://172.25.8.133/WMX/";
  // static String SITE_URL = "http://172.25.8.133/WMX/xmx/";

  // static String BASE_URL = "http://110.5.103.142:9000/";
  // static String SITE_URL = "http://110.5.103.142:9000/xmx/";

  static const String PERU_NAMA = 'PT ROYAL SUTAN AGUNG';
  static const String PERU_SLOGAN = 'ON STOP SUPLY';
  static String lUser_id = "Sys";
  static String lUser_name = "Sys";

  //nambah sendiri
  static String lBin = "";
  static String lCc_no = "";
  static String lPkcc = "";
  static String lOpn_no = "";
  static String lPkopn = "";
  static String lScanner = "";
  static bool scannerActive = true;
  static String Pkdmscnr = "";
  static String Driver = "";
  static String lUser_photoURL = "";
  static String lComp_code = "JKT";
  static String lFkgd = "51";
  static String lGd_code = "JKT-C";
//'txt'
  static String txtPrevix = '';
  // static Map lArrGd = [{'pkgd': 51,'gd_code':'JKT-C'}] ;

  static const MaterialColor theme = MaterialColor(
    0xFF26A69A,
    const <int, Color>{
      50: const Color(0xFFE0F2F1),
      100: const Color(0xFFB2DFDB),
      200: const Color(0xFF80CBC4),
      300: const Color(0xFF4DB6AC),
      400: const Color(0xFF26A69A),
      //title bar
      500: const Color(0xFF009688),
      600: const Color(0xFF00897B),
      700: const Color(0xFF00796B),
      800: const Color(0xFF00695C),
      900: const Color(0xFF004D40),
    },
  );

  static void Alert(BuildContext context) {}

  static notify(String toast, Color color) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        //timeInSecForIos: 1,
        backgroundColor: color,
        textColor: Colors.white);
  }
  static page(BuildContext context,Widget page){
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (c, a1, a2) => page,
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 300),
      ),
    );
  }
}

class sysDate {
  static now() {
    return DateTime.now();
  }

  static format(DateTime val) {
    return DateFormat('dd-MM-yyyy').format(val);
  }
  static formatStr(String val) {
    DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(val);
    return DateFormat('dd-MM-yyyy').format(tempDate);
  }
  static parse(String val) {
    return DateFormat("dd-MM-yyyy").parse(val);
  }

  static diffDay(DateTime startDate, endDate) {
    return startDate.difference(endDate).inDays + 1;
  }

  static bool isCurrentDateInRange(DateTime startDate, DateTime endDate) {
    final currentDate = now();
    // DateTime startDate1 = parse(startDate);
    // DateTime endDate1 = parse(endDate);
    return currentDate.isAfter(startDate) && currentDate.isBefore(endDate);
  }
}

String initCap(String s) => s[0].toUpperCase() + s.substring(1).toLowerCase();

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;

  SlideRightRoute({required this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
  );
}

class ScaleRoute extends PageRouteBuilder {
  final Widget page;

  ScaleRoute({required this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: child,
        ),
  );
}

class Msg extends StatelessWidget {
  final String title;
  final String msg;

  const Msg({Key? key, required this.msg, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const SizedBox(height: 16),
          SelectableText(
            msg,
          ),
        ]),
      ),
    );
  }
}
