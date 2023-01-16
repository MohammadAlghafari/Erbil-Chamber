import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/pref_keys.dart';
import '../../injections.dart';
import 'restart_widget.dart';

class LanguagesDialog extends StatefulWidget {
  @override
  _LanguagesDialogState createState() => _LanguagesDialogState();
}

class _LanguagesDialogState extends State<LanguagesDialog> {
  SharedPreferences prefs;
  String language;

  @override
  void initState() {
    super.initState();
    prefs = serviceLocator<SharedPreferences>();
    language = prefs.getString(PrefsKeys.CULTURE_CODE);
    if (language == null) language = 'en';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              title: Center(child: Text(AppLocalizations.of(context).select_your_prefered_language))),
          SizedBox(height: 15),
          _buildLanguageWidget(
              context: context,
              languageName: 'English',
              imageAsset: 'assets/images/united-states-of-america.png',
              selected: language == 'en' ? true : false,
              onTap: () {
                if (language == 'en') {
                  Navigator.of(context).pop();
                  return;
                }
                prefs.setString(PrefsKeys.CULTURE_CODE, 'en');
                RestartWidget.of(context).restartApp();
              }),
          _buildLanguageWidget(
              context: context,
              languageName: 'كوردى',
              imageAsset: 'assets/images/kurdistan.jpg',
              selected: language == 'fa' ? true : false,
              onTap: () {
                if (language == 'fa') {
                  Navigator.of(context).pop();
                  return;
                }
                prefs.setString(PrefsKeys.CULTURE_CODE, 'fa');
                RestartWidget.of(context).restartApp();
              }),
          _buildLanguageWidget(
              context: context,
              languageName: 'العربية',
              imageAsset: 'assets/images/iraq-flag.png',
              selected: language == 'ar' ? true : false,
              onTap: () {
                if (language == 'ar') {
                  Navigator.of(context).pop();
                  return;
                }
                prefs.setString(PrefsKeys.CULTURE_CODE, 'ar');
                RestartWidget.of(context).restartApp();
              }),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  InkWell _buildLanguageWidget({
    BuildContext context,
    String languageName,
    String imageAsset,
    bool selected,
    Function onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    image: DecorationImage(
                        image: AssetImage(imageAsset), fit: BoxFit.cover),
                  ),
                ),
                Container(
                  height: selected ? 40 : 0,
                  width: selected ? 40 : 0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    color: Colors.grey.withOpacity(selected ? 0.50 : 0),
                  ),
                  child: Icon(
                    Icons.check,
                    size: 24,
                    color: Theme.of(context)
                        .primaryColor
                        .withOpacity(selected ? 0.85 : 0),
                  ),
                ),
              ],
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    languageName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.subtitle1.merge(
                        TextStyle(
                            color: selected
                                ? Theme.of(context).primaryColor
                                : Colors.black)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
