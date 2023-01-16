import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({Key key, this.onTap,}) : super(key: key);
  
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/no_data.png',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
            Text(
              AppLocalizations.of(context).no_data_found,
              style: TextStyle(
                color: Colors.indigo[700],
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              AppLocalizations.of(context).tap_anywhere_to_relode,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }
}
