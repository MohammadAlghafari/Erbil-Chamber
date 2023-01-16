import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/pref_keys.dart';
import '../../infrastructure/common_response/company_response.dart';
import '../../injections.dart';
import '../screens/company_details/company_details_screen.dart';
import 'cached_network_image_view.dart';

class FavoriteCompanyItem extends StatefulWidget {
  const FavoriteCompanyItem(
      {Key key, @required this.companyResponse, @required this.updateView})
      : super(key: key);

  final CompanyResponse companyResponse;
  final Function(String) updateView;

  @override
  _FavoriteCompanyItemState createState() => _FavoriteCompanyItemState();
}

class _FavoriteCompanyItemState extends State<FavoriteCompanyItem> {
  SharedPreferences prefs;
  Map<String, dynamic> favoriteMap;

  @override
  void initState() {
    super.initState();
    prefs = serviceLocator<SharedPreferences>();
    String map = prefs.getString(PrefsKeys.FAVORITE_MAP);
    if (map != null)
      favoriteMap = jsonDecode(prefs.getString(PrefsKeys.FAVORITE_MAP));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2.5,
          )
        ],
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
        borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.of(context)
                .pushNamed(CompanyDetailsScreen.routeName,
                    arguments: widget.companyResponse.id)
                .then((value) {
              if (value != null) widget.updateView(value);
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: widget.companyResponse.logo != null
                          ? ChachedNetwrokImageView(
                              imageUrl:
                                  widget.companyResponse.logo.md.substring(1),
                              isCircle: true,
                            )
                          : Image.asset(
                              'assets/images/company_placeholder.jpg',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.companyResponse.commercialName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.companyResponse.address,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              if (widget.companyResponse.about != null)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    widget.companyResponse.about,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  widget.companyResponse.category.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
