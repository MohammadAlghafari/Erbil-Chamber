import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../infrastructure/company_details/response/opening_day_response.dart';
import 'enums.dart';

class GlobalPurposeFunctions {
  static ProgressDialog progressDialog;

  static void showToast(String message, BuildContext context) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context).primaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static launchURL({@required String url}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> showOrHideProgressDialog(
      BuildContext context, bool isShow) async {
    progressDialog = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
      showLogs: false,
    );
    progressDialog.style(
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Container(
        margin: EdgeInsets.all(15),
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation(
            Theme.of(context).accentColor,
          ),
        ),
      ),
      elevation: 10.0,
      padding: EdgeInsets.all(10),
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 19.0,
        fontWeight: FontWeight.w600,
      ),
      message: AppLocalizations.of(context).loading,
    );
    if (isShow) {
      await progressDialog.show();
    } else {
      await Future.delayed(const Duration(milliseconds: 500), () {
        progressDialog.hide();
      });
    }
  }

  static Future<Position> getdevicePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Position(
          longitude: 44.009167,
          latitude: 36.191113,
          timestamp: null,
          accuracy: null,
          altitude: null,
          heading: null,
          speed: null,
          speedAccuracy: null);
      //return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Position(
            longitude: 44.009167,
            latitude: 36.191113,
            timestamp: null,
            accuracy: null,
            altitude: null,
            heading: null,
            speed: null,
            speedAccuracy: null);

        //return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Position(
          longitude: 44.009167,
          latitude: 36.191113,
          timestamp: null,
          accuracy: null,
          altitude: null,
          heading: null,
          speed: null,
          speedAccuracy: null);

      //return Future.error(
      //    'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  static int convertDayToInt(String current) {
    if (current.toUpperCase() == 'SATURDAY')
      return 1;
    else if (current.toUpperCase() == 'SUNDAY')
      return 2;
    else if (current.toUpperCase() == 'MONDAY')
      return 4;
    else if (current.toUpperCase() == 'TUESDAY')
      return 8;
    else if (current.toUpperCase() == 'WEDNESDAY')
      return 16;
    else if (current.toUpperCase() == 'THURSDAY')
      return 32;
    else
      return 64;
  }

  // ignore: missing_return
  static String handleCompanyCurrentTimeState(
      String currentDay, List<OpeningDayResponse> days, BuildContext context) {
    int current = convertDayToInt(currentDay);
    DateTime now = DateTime.now();

    OpeningDayResponse day =
        days.firstWhere((element) => element.dayOfWeek == current);
    if (day.closed)
      return AppLocalizations.of(context).closed;
    else if (day.alwaysOpen)
      return AppLocalizations.of(context).opened_all_day;
    else {
      if (day.times.length == 1) {
        DateTime open = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(day.times[0].open.substring(0, 2)),
            int.parse(day.times[0].open.substring(3, 5)));
        DateTime close = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(day.times[0].close.substring(0, 2)),
            int.parse(day.times[0].close.substring(3, 5)));
        if (now.isAfter(open) && now.isBefore(close))
          return AppLocalizations.of(context).opened_now +
              ' ' +
              AppLocalizations.of(context).closes_on +
              ' ' +
              day.times[0].close;
        else if (now.isAfter(close))
          return AppLocalizations.of(context).closed;
        else if (now.isBefore(open))
          return AppLocalizations.of(context).closed +
               ' - ' + AppLocalizations.of(context).opens_on + ' ' +
              day.times[0].open;
      } else {
        DateTime open1 = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(day.times[0].open.substring(0, 2)),
            int.parse(day.times[0].open.substring(3, 5)));
        DateTime close1 = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(day.times[0].close.substring(0, 2)),
            int.parse(day.times[0].close.substring(3, 5)));
        DateTime open2 = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(day.times[1].open.substring(0, 2)),
            int.parse(day.times[1].open.substring(3, 5)));
        DateTime close2 = DateTime(
            now.year,
            now.month,
            now.day,
            int.parse(day.times[1].close.substring(0, 2)),
            int.parse(day.times[1].close.substring(3, 5)));
        if (now.isAfter(open1) && now.isBefore(close1))
          return AppLocalizations.of(context).opened_now +
              ' ' +
              AppLocalizations.of(context).closes_on +
              ' ' +
              day.times[0].close;
        else if (now.isAfter(close1) && now.isBefore(open2))
          return AppLocalizations.of(context).closed +
              ' - ' + AppLocalizations.of(context).opens_on + ' ' +
              day.times[1].open;
        else if (now.isAfter(open2) && now.isBefore(close2))
          return AppLocalizations.of(context).opened_now +
              ' ' +
              AppLocalizations.of(context).closes_on +
              ' ' +
              day.times[1].close;
        else
          return AppLocalizations.of(context).closed;
      }
    }
  }

  static String handleSocialMediaIcon(int socailType){
    SocialMediaType type = SocialMediaType.values[socailType];
    switch (type) {
      case SocialMediaType.Website:
        return 'web';
        break;
      case SocialMediaType.Facebook:
        return 'facebook';
        break;
      case SocialMediaType.Twitter:
        return 'twitter';
        break;
      case SocialMediaType.Linkedin:
        return 'linkedin';
        break;
      case SocialMediaType.Whatsapp:
        return 'whatsapp';
        break;
      case SocialMediaType.Telegram:
        return 'telegram';
        break;
      case SocialMediaType.Instagram:
        return 'instagram';
        break;
      case SocialMediaType.Youtube:
        return 'youtube';
        break;
      case SocialMediaType.Skype:
        return 'skype';
        break;
      case SocialMediaType.Email:
        return 'email';
        break;
      default: return '';
    }
  }
}
