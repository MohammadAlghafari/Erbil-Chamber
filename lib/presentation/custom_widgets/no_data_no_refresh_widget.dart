import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoDataNoRefreshWidget extends StatelessWidget {
  const NoDataNoRefreshWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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
        ],
      ),
    );
  }
}
