import 'package:flutter/material.dart';

import '../../infrastructure/common_response/category_response.dart';
import '../screens/companies/companies_screen.dart';
import 'cached_network_image_view.dart';

class CategoryListItem extends StatelessWidget {
  const CategoryListItem({Key key, @required this.category}) : super(key: key);

  final CategoryResponse category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(CompaniesScreen.routeName, arguments: category);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey[700],
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(0, 1),
            )
          ],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(right: 10, top: 10, left: 10),
                width: 45,
                height: 45,
                child: Container(
                  child: category.picture != null && category.picture.md != null
                      ? ChachedNetwrokImageView(
                          imageUrl: category.picture.md.substring(1),
                          isCircle: false,
                        )
                      : Icon(
                          Icons.category_outlined,
                          color: Colors.black,
                          size: 45,
                        ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        margin: EdgeInsets.all(10),
      ),
    );
  }
}
