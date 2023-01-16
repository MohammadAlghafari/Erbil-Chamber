import 'package:flutter/material.dart';

import '../../infrastructure/common_response/company_response.dart';
import '../screens/company_details/company_details_screen.dart';
import 'cached_network_image_view.dart';

class CompanyItem extends StatelessWidget {
  const CompanyItem({Key key, @required this.companyResponse})
      : super(key: key);

  final CompanyResponse companyResponse;
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
            Navigator.of(context).pushNamed(CompanyDetailsScreen.routeName,
                arguments: companyResponse.id);
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
                      child: companyResponse.logo != null
                          ? ChachedNetwrokImageView(
                              imageUrl: companyResponse.logo.md.substring(1),
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
                          companyResponse.commercialName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          companyResponse.address,
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
              if (companyResponse.about != null)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    companyResponse.about,
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
                  companyResponse.category.toString(),
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
