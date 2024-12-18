import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:face_apps/Sys/req.dart';
import 'package:photo_view/photo_view.dart';
import 'package:face_apps/sys.dart';
import 'package:face_apps/Sys/Frm/FormBuilderImagePicker.dart';

/*
* harus manual tambah di form, jangan di export
*
* */
class Img extends StatelessWidget {
  final name, label, url;
  final value;

  Img({required this.name, required this.label, required this.url, this.value});

  Future _deleteImageFromCache(url) async {
    await CachedNetworkImage.evictFromCache(url);
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: FormBuilderImagePicker(
            name: name,
            decoration: InputDecoration(labelText: label),

            maxImages: 3,
            // onImage: (image) {
            //   print(image);
            // },

            previewWidth: 200,
            previewHeight: 150,
            onChanged: (val) {
              try {
                var selectedImg = val!.first;
                var imageBytes = selectedImg.readAsBytesSync(); // convert to bytes
                var base64Image = base64Encode(imageBytes); // convert to string

                Req.post(url, {
                  "name": value,
                  "image": base64Image,
                });
                _deleteImageFromCache(sys.BASE_URL+'FiLe/asset/thumb/'+value+'.jpg');
              } catch (e) {
                print(e);
              }
            },
            onSaved: (val) {
              // print('fff');
            }),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CommonExampleRouteWrapper(
                imageProvider: NetworkImage(sys.BASE_URL+'FiLe/aprv/'+value+'.jpg'),
                loadingBuilder: (context, event) {
                  if (event == null) {
                    return const Center(
                      child: Text("Loading"),
                    );
                  }
                  final value = event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? event.cumulativeBytesLoaded);

                  final percentage = (100 * value).floor();
                  return Center(
                    child: Text("$percentage%"),
                  );
                },
              ),
            ),
          );
        });
  }
}

class CommonExampleRouteWrapper extends StatelessWidget {
  const CommonExampleRouteWrapper({
    this.imageProvider,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialScale,
    this.basePosition = Alignment.center,
    this.filterQuality = FilterQuality.none,
    this.disableGestures,
    this.errorBuilder,
  });

  final ImageProvider? imageProvider;
  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final dynamic initialScale;
  final Alignment basePosition;
  final FilterQuality filterQuality;
  final bool? disableGestures;
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: PhotoView(
          imageProvider: imageProvider,
          loadingBuilder: loadingBuilder,
          backgroundDecoration: backgroundDecoration,
          minScale: minScale,
          maxScale: maxScale,
          initialScale: initialScale,
          basePosition: basePosition,
          filterQuality: filterQuality,
          disableGestures: disableGestures,
          errorBuilder: errorBuilder,
        ),
      ),
    );
  }
}
