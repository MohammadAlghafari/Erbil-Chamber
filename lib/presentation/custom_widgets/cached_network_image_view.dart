import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../infrastructure/api/urls.dart';

class ChachedNetwrokImageView extends StatelessWidget {
  final String imageUrl;
  final bool isCircle;
  final double width;
  final double height;
  final bool withBaseUrl;
  final BoxFit boxFit;
  final Color blendColor;
  ChachedNetwrokImageView({
    this.height = 60,
    this.width = 60,
    this.imageUrl = "",
    this.isCircle = false,
    this.withBaseUrl = true,
    this.boxFit = BoxFit.cover,
    this.blendColor,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius:
            (isCircle) ? BorderRadius.circular(100) : BorderRadius.circular(0),
        child: CachedNetworkImage(
          imageUrl: (withBaseUrl)
              ? Urls.BASE_URL + ((imageUrl == null) ? "" : imageUrl)
              : "" + ((imageUrl == null) ? "" : imageUrl),
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
              child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).accentColor,
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
          )),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: boxFit,
          color: blendColor,
        ),
      ),
    );
  }
}
