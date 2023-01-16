import 'package:flutter/material.dart';

import '../../../infrastructure/common_response/company_response.dart';
import '../../custom_widgets/company_item.dart';

class CompanyDetailsBranchesScreen extends StatefulWidget {
  CompanyDetailsBranchesScreen({Key key, @required this.branches})
      : super(key: key);

  final List<CompanyResponse> branches;
  @override
  _CompanyDetailsBranchesScreenState createState() =>
      _CompanyDetailsBranchesScreenState();
}

class _CompanyDetailsBranchesScreenState
    extends State<CompanyDetailsBranchesScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: EdgeInsets.only(top: 5.0 ),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            CompanyItem(companyResponse: widget.branches[index]),
        itemCount: widget.branches.length,
        shrinkWrap: true,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
