import 'package:flutter/material.dart';

import '../../../application/near_by/near_by_bloc.dart';
import '../../../infrastructure/common_response/company_response.dart';
import '../../custom_widgets/near_by_company_item.dart';
import '../../custom_widgets/no_data_widget.dart';

class NearByListScreen extends StatefulWidget {
  NearByListScreen(
      {Key key, @required this.nearByCompanies, @required this.nearByBloc})
      : super(key: key);

  final List<CompanyResponse> nearByCompanies;
  final NearByBloc nearByBloc;
  @override
  _NearByListScreenState createState() => _NearByListScreenState();
}

class _NearByListScreenState extends State<NearByListScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        widget.nearByBloc.add(NearByCompaniesFetchEvent(
            refresh: widget.nearByCompanies.isEmpty ? false : true));
      },
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) => widget
                .nearByCompanies.isEmpty
            ? NoDataWidget(
                onTap: () => widget.nearByBloc.add(NearByCompaniesFetchEvent()),
              )
            : NearByCompanyItem(companyResponse: widget.nearByCompanies[index]),
        itemCount:
            widget.nearByCompanies.isEmpty ? 1 : widget.nearByCompanies.length,
        shrinkWrap: true,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
