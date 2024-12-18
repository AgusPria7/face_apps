import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'dart:io';

class ImageSlider extends StatefulWidget {
  List<String> imageList;
  String url;
  ImageSlider({Key? key, required this.imageList,required this.url}) : super(key: key);

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _current = 0;
  String _title = '';
  final CarouselController _controller = CarouselController();
  @override
  void initState() {
    // TODO: implement initState
    // for (var img in widget.imageList){
    //   if(img==widget.url){
    //     setState(() {
    //       _current
    //     });
    //   }
    // }

    setState(() {
      File file = new File(widget.imageList[_current]);
      _title =file.path.split('/').last;// widget.imageList[index];
    });
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: Column(children: [
        // SizedBox(height: 325.0),
        CarouselSlider(
          options: CarouselOptions(
              height: MediaQuery.of(context).size.height - 150,
              viewportFraction: 1,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              autoPlay: false,
              onPageChanged: (index, reason) {
                setState(() {
                  //print(widget.imageList);
                  _current = index;
                  File file = new File(widget.imageList[index]);

                  _title =file.path.split('/').last;// widget.imageList[index];
                });
              }),
          items: widget.imageList
              .map((item) => ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      ExtendedImage.network(
                        item,
                        fit: BoxFit.contain,
                        mode: ExtendedImageMode.gesture,
                        initGestureConfigHandler: (state) {
                          return GestureConfig(
                            minScale: 0.8,
                            animationMinScale: 0.7,
                            maxScale: 3.0,
                            animationMaxScale: 3.5,
                            speed: 1.0,
                            inertialSpeed: 100.0,
                            initialScale: 1.0,
                            inPageView: false,
                            initialAlignment: InitialAlignment.center,
                          );
                        },
                        height: double.infinity,
                        width: double.infinity,
                      ),
                      //
                    ],
                  )))
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imageList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ]),
    );
  }
}
