import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../infrastructure/common_response/category_response.dart';
import 'cached_network_image_view.dart';

class SubCategoryListItem extends StatelessWidget {
  const SubCategoryListItem(
      {Key key,
      @required this.subCategory,
      @required this.selected,
      @required this.onTap})
      : super(key: key);
  final Function onTap;
  final CategoryResponse subCategory;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: 110,
          decoration: BoxDecoration(
              gradient: selected
                  ? LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [0.1, 0.5, 0.7, 0.8, 0.9],
                      colors: [
                        Colors.indigo[800],
                        Colors.indigo[700],
                        Colors.indigo[600],
                        Colors.indigo[400],
                        Colors.indigo[300],
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [0.1, 0.5, 0.7, 0.8, 0.9],
                      colors: [
                        Colors.grey[300],
                        Colors.grey[200],
                        Colors.grey[200],
                        Colors.white,
                        Colors.white,
                      ],
                    ),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300],
                    blurRadius: 5,
                    offset: Offset(0, 5))
              ],
              border: Border.all(
                color: selected ? Colors.white : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(15)),

          child: InkWell(
            // borderRadius: BorderRadius.circular(100),
            onTap: onTap,
            child: Center(
              child: Text(
                subCategory.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    color: selected ? Colors.white : Colors.black),
              ),
            ),
          ),
          margin: EdgeInsets.only(
            top: 30,
            right: 10,
            left: 10,
            bottom: 10,
          ),
        ),
        Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: selected
                  ? LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [0.1, 0.5, 0.7, 0.8, 0.9],
                      colors: [
                        Colors.indigo[800],
                        Colors.indigo[700],
                        Colors.indigo[600],
                        Colors.indigo[400],
                        Colors.indigo[300],
                      ],
                    )
                  : LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [0.1, 0.5, 0.7, 0.8, 0.9],
                      colors: [
                        Colors.grey[300],
                        Colors.grey[200],
                        Colors.grey[200],
                        Colors.white,
                        Colors.white,
                      ],
                    ),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300],
                    blurRadius: 2,
                    offset: Offset(0, 1))
              ],
              border: Border.all(
                color: selected ? Colors.white : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(50)),
          child: subCategory.id == '-1'
              ? SvgPicture.asset(
                  subCategory.picture.md,
                  color: selected ? Colors.white : Colors.black,
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                )
              : subCategory.picture != null
                  ? ChachedNetwrokImageView(
                      width: 30,
                      height: 30,
                      blendColor: selected ? Colors.white : Colors.black,
                      imageUrl: subCategory.picture.md.substring(1),
                      isCircle: false,
                    )
                  : Icon(
                      Icons.category_outlined,
                      color: selected ? Colors.white : Colors.black,
                      size: 30,
                    ),
        ),
      ],
    );
  }
}
