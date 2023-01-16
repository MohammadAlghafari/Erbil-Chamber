import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../../infrastructure/api/urls.dart';
import '../../../infrastructure/common_response/picture_response.dart';

class SinglePhotoViewScreen extends StatefulWidget {
  static const routeName = '/single_photo_view_screen';
  SinglePhotoViewScreen({Key key, @required this.photo}) : super(key: key);

  final PictureResponse photo;
  @override
  _SinglePhotoViewScreenState createState() => _SinglePhotoViewScreenState();
}

class _SinglePhotoViewScreenState extends State<SinglePhotoViewScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            PhotoView(
                imageProvider: CachedNetworkImageProvider(
                    Urls.BASE_URL + widget.photo.lg.substring(1)),
                maxScale: PhotoViewComputedScale.covered * 2.0,
                minScale: PhotoViewComputedScale.contained * 1,
                heroAttributes: PhotoViewHeroAttributes(tag: widget.photo.lg),
                initialScale: PhotoViewComputedScale.contained),
            PositionedDirectional(
              top: 0,
              start: 0,
                child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ))
          ],
        ),
      ),
    );
  }
}
