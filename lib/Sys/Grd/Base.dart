import 'package:flutter/material.dart';
import 'package:face_apps/Sys/req.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'dart:async';

import '../req.dart';

void _doNothing(dynamic _) {}

class GrdBase extends StatefulWidget {
  final String url;
  String readUrl;
  final List<Map> filters;
  final Function(dynamic, dynamic) listing;
  final Function(dynamic)? form;
  final Function(dynamic)? onSelect;
  final Function(dynamic) onRead;
  bool? addButton;
  Widget? floatingActionButton;
  final int pageSize;
  final List<Widget>? actionsBtn;
  GrdBase(
      {Key? key,
        required this.url,
        this.readUrl = 'read',
        required this.filters,
        required this.listing,
        this.form,
        this.onSelect,
        this.onRead=_doNothing,
        this.addButton = false,
        this.floatingActionButton,
        this.pageSize = 20,
        this.actionsBtn})
      : super(key: key);

  @override
  GrdBaseState createState() => GrdBaseState();
}

class GrdBaseState extends State<GrdBase> {
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
    return buildBody();
  }

  Widget buildBody() {
    return PagedSliverList<int, dynamic>(
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
                if (widget.form != null) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) =>
                      widget.form!(rec['pk'])))
                      .whenComplete(() {
                    refresh();
                  });
                }
              }
            },
            child: widget.listing(rec, i),
          ),
        ),
      ),
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
      widget.onRead(newItems);
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      //print(error);
      pagingController.error = error;
    }
  }

  void updatesearchText(String searchText) {
    _searchText = searchText;
    pagingController.refresh();
  }
  void clearSearchText() {
    _searchText = '';
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
