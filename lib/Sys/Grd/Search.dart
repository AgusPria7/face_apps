import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/src/transformers/backpressure/debounce.dart';
import 'package:face_apps/sys.dart';

class TxtSearch extends StatefulWidget {
  List<Widget>? actions;
  TxtSearch({Key? key, this.onChanged, this.debounceTime, this.actions})
      : super(key: key);
  final ValueChanged<String>? onChanged;
  final Duration? debounceTime;

  @override
  _TxtSearchState createState() => _TxtSearchState();
}

class _TxtSearchState extends State<TxtSearch> {
  final StreamController<String> _textChangeStreamController =
      StreamController();
  late StreamSubscription _textChangesSubscription;
  final _txtSearch = TextEditingController();
  int _txtLength = 0;

  @override
  void initState() {
    _textChangesSubscription = _textChangeStreamController.stream
        .debounceTime(
          widget.debounceTime ?? const Duration(seconds: 1),
        )
        .distinct()
        .listen((text) {
      final onChanged = widget.onChanged;
      if (onChanged != null) {
        onChanged(text);
        setState(() {
          _txtLength = text.length;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) => SliverAppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        floating: false,
        pinned: true,
        actions: widget.actions,
        title: Container(
          child: TextFormField(
            autofocus: false,
            controller: _txtSearch,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
              hintText: 'Cari Data',
              border: UnderlineInputBorder(),
              // suffixIcon: _txtLength > 0
              //     ? IconButton(
              //         icon: Icon(
              //           Icons.clear,
              //           color:Colors.red
              //         ),
              //         onPressed: () {
              //           _txtSearch.clear();
              //           final onChanged = widget.onChanged;
              //           if (onChanged != null) {
              //             onChanged('');
              //             setState(() {
              //               _txtLength = 0;
              //             });
              //           }
              //
              //         },
              //       )
              //     : null,
              //  contentPadding: EdgeInsets.all(20),
            ),
            onChanged: _textChangeStreamController.add,
          ),
        ),
      );

  @override
  void dispose() {
    _textChangeStreamController.close();
    _textChangesSubscription.cancel();
    super.dispose();
  }
}
