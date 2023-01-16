import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:erbilchamberapp/infrastructure/common_response/company_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';

import '../../../application/near_by/near_by_bloc.dart';
import '../../../injections.dart';
import '../../custom_widgets/loading_widget.dart';
import '../../custom_widgets/server_error_widget.dart';
import '../near_by_list/near_by_list_screen.dart';
import '../near_by_map/near_by_map_screen.dart';

class NearByScreen extends StatefulWidget {
  NearByScreen({Key key}) : super(key: key);

  @override
  _NearByScreenState createState() => _NearByScreenState();
}

class _NearByScreenState extends State<NearByScreen> {
  NearByBloc nearByBloc;
  List<CompanyResponse> nearByCompanies;
  Position deviceLocation;

  @override
  void initState() {
    super.initState();
    nearByBloc = serviceLocator<NearByBloc>();
    nearByBloc.add(NearByCompaniesFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).near_by,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: BlocProvider(
        create: (context) => nearByBloc,
        child: BlocListener<NearByBloc, NearByState>(
          listener: (context, state) {
            if (state is NearByCompaniesFetchedState) {
              nearByCompanies = state.nearByCompanies;
              deviceLocation = state.deviceLocation;
            }
          },
          child: BlocBuilder<NearByBloc, NearByState>(
            builder: (context, state) {
              if (state is LoadingNearByState) {
                return LoadingWidget();
              } else if (state is ErrorNearByState) {
                return ServerErrorWidget(
                  onTap: () {
                    nearByBloc.add(NearByCompaniesFetchEvent());
                  },
                );
              } else if (nearByCompanies != null) {
                return DefaultTabController(
                  length: 2,
                  child: Column(
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(maxHeight: 150.0),
                        child: Material(
                          color: Colors.white,
                          child: TabBar(
                            labelColor: Colors.white,
                            unselectedLabelColor: Theme.of(context).primaryColor,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BubbleTabIndicator(
                              indicatorColor: Theme.of(context).primaryColor,
                              indicatorHeight: 40,
                              tabBarIndicatorSize: TabBarIndicatorSize.tab,
                               
                               indicatorRadius: 25,
                            ),
                            labelStyle: TextStyle(fontWeight: FontWeight.bold),
                            tabs: [
                              Tab(
                                text: AppLocalizations.of(context).map,
                              ),
                              Tab(
                                text: AppLocalizations.of(context).list,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          child: TabBarView(children: [
                        Container(
                          child: NearByMapScreen(
                            nearByCompanies: nearByCompanies,
                            deviceLocation: deviceLocation,
                          ),
                        ),
                        Container(
                          child: NearByListScreen(
                            nearByCompanies: nearByCompanies,
                            nearByBloc: nearByBloc,
                          ),
                        ),
                      ]))
                    ],
                  ),
                );
              } else
                return Container();
            },
          ),
        ),
      ),
    );
  }
}
