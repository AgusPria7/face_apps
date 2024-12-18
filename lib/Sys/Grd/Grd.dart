import 'package:flutter/material.dart';
import 'package:face_apps/Sys/Grd/Search.dart';
import 'package:face_apps/Sys/req.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../SysAppBar.dart';

import 'dart:async';

void _doNothing(dynamic _) {}

class Grd extends StatefulWidget {
  final String title, url;
  String readUrl;
  final List<Map> filters;
  final Function(dynamic) listing;
  final Function(dynamic)? form;
  final Function(dynamic)? onSelect;
  bool? addButton;
  Widget? headCont;
  Widget? floatingActionButton;
  final int pageSize;
  final List<Widget>? actionsBtn;
  Grd(
      {Key? key,
      required this.title,
      required this.url,
      this.readUrl = 'read',
      required this.filters,
      required this.listing,
      this.headCont,
      this.form,
      this.onSelect,
      this.addButton = false,
      this.floatingActionButton,
      this.pageSize = 20,
      this.actionsBtn})
      : super(key: key);

  @override
  GrdState createState() => GrdState();
}

class GrdState extends State<Grd> {
  //final int pageSize = 20;
  final PagingController<int, dynamic> pagingController = PagingController(firstPageKey: 0);
  String _searchText = '';
  String _lwhere = '';
  late String readUrl = "";

  //late Function(dynamic) onSelected()=>refresh(rec);
  @override
  void initState() {
    readUrl = widget.url + '/' + widget.readUrl;

    pagingController.addPageRequestListener((pageKey) {
      read(pageKey);
    });

    pagingController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Ada masalah ketika membuka halaman.',
            ),
            action: SnackBarAction(
              label: 'Coba Kembali',
              onPressed: () => pagingController.retryLastFailedRequest(),
            ),
          ),
        );
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget wgtSearch;
    Widget wgtSearch2;
    if (widget.headCont == null) {
      wgtSearch = TxtSearch(
        onChanged: (searchText) => updatesearchText(searchText),
      );
    } else {
      wgtSearch = widget.headCont!;
    }
    return Scaffold(
        appBar: SysAppBar(
            title: widget.title,
            actions: widget.actionsBtn ??
                [
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      refresh();
                    },
                    color: Colors.white,
                  )
                ]),
        resizeToAvoidBottomInset: false,

        floatingActionButton: (widget.addButton == false)
            ? null
            : widget.floatingActionButton ??
                FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: (() => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (BuildContext context) => widget.form!(null)))
                          .whenComplete(() {
                        refresh();
                      })),
                  tooltip: 'Add',
                ),
        body: buildBody(wgtSearch));
  }

  Widget buildBody(wgtSearch) {
    return CustomScrollView(
      slivers: <Widget>[
        wgtSearch,
        // SliverToBoxAdapter(
        //   child: SizedBox(
        //     height: 20,
        //     child: Center(
        //       child: Text('Scroll to see the SliverAppBar in effect.'),
        //     ),
        //   ),
        // ),
        PagedSliverList<int, dynamic>(
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            animateTransitions: true,
            itemBuilder: (context, rec, i) => Container(
              child: GestureDetector(
                onTap: () {
                  //--untuk txtSrc -- callback isi txt
                  if (widget.onSelect != null) {
                    widget.onSelect!(rec);
                  } else {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (BuildContext context) => widget.form!(rec['pk'])))
                        .whenComplete(() {
                      refresh();
                    });
                  }
                },
                child: widget.listing(rec),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> read(pageKey) async {
    try {
      Map extraParams = {};
      if (_lwhere != '') {
        extraParams['lwhere'] = _lwhere;
      }
      final newItems = await Req.read(readUrl, pageKey, widget.pageSize, _searchText, widget.filters, extraParams);
      final isLastPage = newItems.length < widget.pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      print(error);
      pagingController.error = error;
    }
  }

  void updatesearchText(String searchText) {
    _searchText = searchText;
    pagingController.refresh();
  }

  void setWhere(String lwhere) {
    _lwhere = lwhere;
    pagingController.refresh();
  }

  void refresh() {
    pagingController.refresh();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}
