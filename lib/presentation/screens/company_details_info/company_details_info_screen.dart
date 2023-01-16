import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

import '../../../common/global_purpose_functions.dart';
import '../../../infrastructure/company_details/response/company_details_response.dart';
import '../../../infrastructure/company_details/response/opening_day_response.dart';
import '../../../infrastructure/company_details/response/social_media_response.dart';
import '../../custom_widgets/cached_network_image_view.dart';

class CompanyDetailsInfoScreen extends StatefulWidget {
  const CompanyDetailsInfoScreen({
    Key key,
    @required this.companyDetails,
  }) : super(key: key);

  final CompanyDetailsResponse companyDetails;

  @override
  _CompanyDetailsInfoScreenState createState() =>
      _CompanyDetailsInfoScreenState();
}

class _CompanyDetailsInfoScreenState extends State<CompanyDetailsInfoScreen>
    with AutomaticKeepAliveClientMixin {
  String currentDay = DateFormat('EEEE').format(DateTime.now());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 5, right: 5, left: 5),
            padding: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.indigo[700],
                  Colors.indigo[600],
                  Colors.indigo[400],
                  Colors.indigo[300],
                  Colors.indigo[300],
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 3.0,
                )
              ],
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: widget.companyDetails.logo != null
                          ? ChachedNetwrokImageView(
                              imageUrl:
                                  widget.companyDetails.logo.md.substring(1),
                              isCircle: true,
                            )
                          : Image.asset(
                              'assets/images/company_placeholder.jpg',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Text(
                    widget.companyDetails.commercialName,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          widget.companyDetails.address,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(25),
                          onTap: () {
                            GlobalPurposeFunctions.launchURL(
                                url:
                                    'https://www.google.com/maps/search/?api=1&query=${widget.companyDetails.latitude},${widget.companyDetails.longitude}');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.location_on,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, left: 10, right: 10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 3.0,
                )
              ],
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Column(
              children: [
                _buildInfoCardHeader(
                    title: AppLocalizations.of(context).general_information,
                    icon: Icons.info_outline),
                Divider(
                  endIndent: 20,
                  indent: 20,
                  height: 2,
                  color: Colors.black,
                ),
                SizedBox(
                  height: 10,
                ),
                _buildTile(
                    title: AppLocalizations.of(context).merchant_name,
                    body: widget.companyDetails.merchantName,
                    icon: Icons.person_outline),
                _buildTile(
                    title: AppLocalizations.of(context).registration_number,
                    body: widget.companyDetails.registrationNumber.toString(),
                    icon: Icons.vpn_key_outlined),
                _buildTile(
                    title: AppLocalizations.of(context).reservation_date,
                    body:
                        widget.companyDetails.reservationDate.substring(0, 10),
                    icon: Icons.date_range),
                _buildTile(
                    title: AppLocalizations.of(context).registration_date,
                    body:
                        widget.companyDetails.registrationDate.substring(0, 10),
                    icon: Icons.date_range),
                _buildAbout(
                    about: widget.companyDetails.about, context: context),
                _buildWorkHours(
                    context: context,
                    openingDays: widget.companyDetails.openingDays,
                    currentDay: currentDay),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, left: 10, right: 10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 3.0,
                )
              ],
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Column(
              children: [
                _buildInfoCardHeader(
                    title: AppLocalizations.of(context).contact_information,
                    icon: Icons.info_outline),
                Divider(
                  endIndent: 20,
                  indent: 20,
                  height: 2,
                  color: Colors.black,
                ),
                SizedBox(
                  height: 10,
                ),
                for (var i = 0;
                    i < widget.companyDetails.contactNumbers.length;
                    i++)
                  _buildTile(
                    title: AppLocalizations.of(context).contact_number,
                    body: widget.companyDetails.contactNumbers[i],
                    icon: Icons.phone_outlined,
                    onTap: () {
                      GlobalPurposeFunctions.launchURL(
                          url:
                              'tel:${widget.companyDetails.contactNumbers[i]}');
                    },
                  ),
                if (widget.companyDetails.socialMedia != null &&
                    widget.companyDetails.socialMedia.length > 0)
                  _buildSocialMediaWidget(widget.companyDetails.socialMedia),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.all(5),
              height: 200,
              child: GoogleMap(
                onMapCreated: (controller) {
                  controller
                      .showMarkerInfoWindow(MarkerId(widget.companyDetails.id));
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.companyDetails.latitude,
                      widget.companyDetails.longitude),
                  zoom: 12,
                ),
                gestureRecognizers: Set()
                  ..add(Factory<PanGestureRecognizer>(
                      () => PanGestureRecognizer()))
                  ..add(
                    Factory<VerticalDragGestureRecognizer>(
                        () => VerticalDragGestureRecognizer()),
                  )
                  ..add(
                    Factory<HorizontalDragGestureRecognizer>(
                        () => HorizontalDragGestureRecognizer()),
                  )
                  ..add(
                    Factory<ScaleGestureRecognizer>(
                        () => ScaleGestureRecognizer()),
                  ),
                markers: {
                  Marker(
                      markerId: MarkerId(widget.companyDetails.id),
                      infoWindow: InfoWindow(
                        title: widget.companyDetails.commercialName,
                      ),
                      position: LatLng(
                        widget.companyDetails.latitude,
                        widget.companyDetails.longitude,
                      )),
                },
              )),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

Widget _buildTile(
    {@required String title,
    @required String body,
    @required IconData icon,
    Function onTap}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.indigo,
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (body != null) SizedBox(height: 3),
                if (body != null)
                  Text(
                    body,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Widget _buildInfoCardHeader({
  @required String title,
  @required IconData icon,
}) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.indigo,
        ),
        SizedBox(
          width: 15,
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget _buildAbout({@required String about, @required BuildContext context}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 15.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.help_outline_outlined,
          color: Colors.indigo,
        ),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).about,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 3),
              ReadMoreText(
                about,
                trimLines: 2,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
                colorClickableText: Colors.indigo,
                trimMode: TrimMode.Line,
                trimCollapsedText: AppLocalizations.of(context).show_more,
                trimExpandedText: AppLocalizations.of(context).show_less,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildWorkHours(
    {BuildContext context,
    List<OpeningDayResponse> openingDays,
    String currentDay}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 15.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.access_time,
          color: Colors.indigo,
        ),
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).work_hours,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 3),
              _buildWorkDaysWidget(context, openingDays, currentDay),
            ],
          ),
        ),
      ],
    ),
  );
}

ExpansionTile _buildWorkDaysWidget(BuildContext context,
    List<OpeningDayResponse> openingDays, String currentDay) {
  return ExpansionTile(
    title: Text(
      GlobalPurposeFunctions.handleCompanyCurrentTimeState(
          currentDay, openingDays, context),
      style: TextStyle(
        color: Colors.indigo,
        fontSize: 15,
        fontWeight: FontWeight.w300,
      ),
    ),
    childrenPadding: EdgeInsets.symmetric(
      horizontal: 15,
    ),
    children: [
      Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Text(
              AppLocalizations.of(context).saturday,
              style: _buildWorkHoursTextStyle('Saturday', currentDay),
            )),
            _buildDayTimes('Saturday', 0, openingDays, context, currentDay),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Text(
              AppLocalizations.of(context).sunday,
              style: _buildWorkHoursTextStyle('Sunday', currentDay),
            )),
            _buildDayTimes('Sunday', 1, openingDays, context, currentDay),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Text(
              AppLocalizations.of(context).monday,
              style: _buildWorkHoursTextStyle('Monday', currentDay),
            )),
            _buildDayTimes('Monday', 2, openingDays, context, currentDay),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Text(
              AppLocalizations.of(context).tuesday,
              style: _buildWorkHoursTextStyle('Tuesday', currentDay),
            )),
            _buildDayTimes('Tuesday', 3, openingDays, context, currentDay),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Text(
              AppLocalizations.of(context).wednesday,
              style: _buildWorkHoursTextStyle('Wednesday', currentDay),
            )),
            _buildDayTimes('Wednesday', 4, openingDays, context, currentDay),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Text(
              AppLocalizations.of(context).thursday,
              style: _buildWorkHoursTextStyle('Thursday', currentDay),
            )),
            _buildDayTimes('Thursday', 5, openingDays, context, currentDay),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Text(
              AppLocalizations.of(context).friday,
              style: _buildWorkHoursTextStyle('Friday', currentDay),
            )),
            _buildDayTimes('Friday', 6, openingDays, context, currentDay),
          ],
        ),
      ),
    ],
  );
}

Column _buildDayTimes(
    String day,
    int dayNum,
    List<OpeningDayResponse> openingDays,
    BuildContext context,
    String currentDay) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      openingDays[dayNum].closed
          ? Text(
              AppLocalizations.of(context).closed,
              style: _buildWorkHoursTextStyle(day, currentDay),
            )
          : openingDays[dayNum].alwaysOpen
              ? Text(
                  AppLocalizations.of(context).opened_all_day,
                  style: _buildWorkHoursTextStyle(day, currentDay),
                )
              : Padding(
                  padding: EdgeInsets.all(0.0),
                ),
      for (var i = 0; i < openingDays[dayNum].times.length; i++)
        Text(
          openingDays[dayNum].times[i].open +
              ' - ' +
              openingDays[dayNum].times[i].close,
          style: _buildWorkHoursTextStyle(day, currentDay),
        ),
    ],
  );
}

TextStyle _buildWorkHoursTextStyle(String day, String currentDay) {
  return TextStyle(
    fontWeight: currentDay == day ? FontWeight.w600 : FontWeight.w300,
    color: currentDay == day ? Colors.indigo : Colors.black,
  );
}

Widget _buildSocialMediaWidget(List<SocialMediaResponse> socialMedia) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(
      horizontal: 5,
      vertical: 5,
    ),
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.indigo[50],
    ),
    child: Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: socialMedia.map((item) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              GlobalPurposeFunctions.launchURL(
                url: item.url,
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SvgPicture.asset(
                'assets/svg/${GlobalPurposeFunctions.handleSocialMediaIcon(item.type)}.svg',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }).toList(),
      direction: Axis.horizontal,
      alignment: socialMedia.length > 5
          ? WrapAlignment.start
          : WrapAlignment.spaceAround,
      runAlignment: WrapAlignment.start,
      verticalDirection: VerticalDirection.down,
    ),
  );
}
