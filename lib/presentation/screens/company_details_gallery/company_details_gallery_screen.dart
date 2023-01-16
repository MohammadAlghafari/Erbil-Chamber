import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../infrastructure/api/urls.dart';
import '../../../infrastructure/common_response/picture_response.dart';
import '../single_photo_view/single_photo_view_screen.dart';

class CompanyDetailsGalleryScreen extends StatefulWidget {
  const CompanyDetailsGalleryScreen({Key key, @required this.photos})
      : super(key: key);

  final List<PictureResponse> photos;

  @override
  _CompanyDetailsGalleryScreenState createState() =>
      _CompanyDetailsGalleryScreenState();
}

class _CompanyDetailsGalleryScreenState
    extends State<CompanyDetailsGalleryScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,),
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(SinglePhotoViewScreen.routeName,
                  arguments: widget.photos[index]);
            },
            child: Container(
              margin: EdgeInsets.all(5),
              child: Hero(
                tag: widget.photos[index].lg,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                    width: 190,
                    height: 190,
                      imageUrl: Urls.BASE_URL + widget.photos[index].lg.substring(1),
                      fit: BoxFit.cover,
                    ),
                ),
              ),
            ),
          ),
          itemCount: widget.photos.length,
          shrinkWrap: true,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
