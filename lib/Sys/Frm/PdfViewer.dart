import 'package:flutter/material.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';

class PdfViewer extends StatefulWidget {
  final String url,filename;

  PdfViewer({Key? key, this.url='',this.filename=''}) : super(key: key);


  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  bool _isLoading = true;
  late PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    PDFDocument docx = await PDFDocument.fromURL(widget.url,
      // cacheManager: CacheManager(
      //     Config(
      //       "customCacheKey",
      //       stalePeriod: const Duration(days: 2),
      //       maxNrOfCacheObjects: 10,
      //     ),
      //   ),
    );
    setState(() {
      document=docx;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filename),
        elevation: 0.0,
        bottomOpacity: 0.0,
      ),
      body: Center(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : PDFViewer(
          document: document,
          lazyLoad: false,
          zoomSteps: 1,
          //uncomment below line to preload all pages
          // lazyLoad: false,
          // uncomment below line to scroll vertically
          // scrollDirection: Axis.vertical,

          //uncomment below code to replace bottom navigation with your own
          /* navigationBuilder:
                      (context, page, totalPages, jumpToPage, animateToPage) {
                    return ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.first_page),
                          onPressed: () {
                            jumpToPage()(page: 0);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            animateToPage(page: page - 2);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            animateToPage(page: page);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.last_page),
                          onPressed: () {
                            jumpToPage(page: totalPages - 1);
                          },
                        ),
                      ],
                    );
                  }, */
        ),
      ),
    );
  }
}
