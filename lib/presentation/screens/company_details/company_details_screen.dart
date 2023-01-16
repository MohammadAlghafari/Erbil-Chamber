import 'dart:convert';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../application/company_details/company_details_bloc.dart';
import '../../../common/pref_keys.dart';
import '../../../infrastructure/company_details/response/company_details_response.dart';
import '../../../injections.dart';
import '../../custom_widgets/loading_widget.dart';
import '../../custom_widgets/server_error_widget.dart';
import '../company_details_branches/company_details_branches_screen.dart';
import '../company_details_gallery/company_details_gallery_screen.dart';
import '../company_details_info/company_details_info_screen.dart';

class CompanyDetailsScreen extends StatefulWidget {
  CompanyDetailsScreen({Key key, @required this.companyId}) : super(key: key);
  static const routeName = '/company_details_screen';
  final String companyId;

  @override
  _CompanyDetailsScreenState createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  CompanyDetailsBloc companyDetailsBloc;
  CompanyDetailsResponse companyDetails;
  SharedPreferences prefs;
  Map<String, dynamic> favoriteMap;
  bool favorited;

  @override
  void initState() {
    super.initState();
    companyDetailsBloc = serviceLocator<CompanyDetailsBloc>();
    companyDetailsBloc.add(CompanyDetailsFetchEvent(id: widget.companyId));
    prefs = serviceLocator<SharedPreferences>();
    String map = prefs.getString(PrefsKeys.FAVORITE_MAP);
    if (map != null)
      favoriteMap = jsonDecode(prefs.getString(PrefsKeys.FAVORITE_MAP));
    favorited = (favoriteMap != null &&
            favoriteMap[widget.companyId] != null &&
            favoriteMap[widget.companyId])
        ? true
        : false;
  }

  Future<bool> _onWillPop() async {
    favorited
        ? Navigator.of(context).pop()
        : Navigator.of(context).pop(widget.companyId);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => companyDetailsBloc,
      child: BlocListener<CompanyDetailsBloc, CompanyDetailsState>(
        listener: (context, state) {
          if (state is CompanyDetailsSuccessState)
            companyDetails = state.companyDetails;
        },
        child: BlocBuilder<CompanyDetailsBloc, CompanyDetailsState>(
          builder: (context, state) {
            return companyDetails != null
                ? WillPopScope(
                    onWillPop: _onWillPop,
                    child: Scaffold(
                      appBar: AppBar(
                        actions: [
                          IconButton(
                              icon: Icon((favoriteMap != null &&
                                      favoriteMap[companyDetails.id] != null &&
                                      favoriteMap[companyDetails.id])
                                  ? Icons.favorite
                                  : Icons.favorite_border),
                              onPressed: () {
                                BlocProvider.of<CompanyDetailsBloc>(context)
                                    .add(SwitchFavoriteEvent(
                                  commpanyId: companyDetails.id,
                                  map: favoriteMap,
                                ));
                                favorited = !favorited;
                              }),
                        ],
                        automaticallyImplyLeading: true,
                        elevation: 0.0,
                        centerTitle: true,
                        title: Text(
                          companyDetails.commercialName,
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                      ),
                      body: DefaultTabController(
                        length: (companyDetails.pictures.length > 0 &&
                                companyDetails.branches.length > 0 &&
                                companyDetails.menu.length > 0)
                            ? 4
                            : ((companyDetails.pictures.length > 0 &&
                                        companyDetails.branches.length > 0) ||
                                    (companyDetails.pictures.length > 0 &&
                                        companyDetails.menu.length > 0) ||
                                    (companyDetails.branches.length > 0 &&
                                        companyDetails.menu.length > 0))
                                ? 3
                                : (companyDetails.pictures.length > 0 ||
                                        companyDetails.branches.length > 0 ||
                                        companyDetails.menu.length > 0)
                                    ? 2
                                    : 0,
                        child: Column(
                          children: <Widget>[
                            Container(
                              constraints: BoxConstraints(
                                  maxHeight: companyDetails.pictures.length >
                                              0 ||
                                          companyDetails.branches.length > 0 ||
                                          companyDetails.menu.length > 0
                                      ? 150
                                      : 0),
                              child: Material(
                                color: Colors.white,
                                child: TabBar(
                                  labelColor: Colors.white,
                                  unselectedLabelColor:
                                      Theme.of(context).primaryColor,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicator: BubbleTabIndicator(
                                    indicatorColor:
                                        Theme.of(context).primaryColor,
                                    indicatorHeight: 40,
                                    tabBarIndicatorSize:
                                        TabBarIndicatorSize.tab,
                                    indicatorRadius: 25,
                                  ),
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  tabs: [
                                    if (companyDetails.pictures.length > 0 ||
                                        companyDetails.branches.length > 0 ||
                                        companyDetails.menu.length > 0)
                                      Tab(
                                        text: AppLocalizations.of(context).info,
                                      ),
                                    if (companyDetails.branches.length > 0)
                                      Tab(
                                        text: AppLocalizations.of(context)
                                            .branches,
                                      ),
                                    if (companyDetails.pictures.length > 0)
                                      Tab(
                                        text: AppLocalizations.of(context)
                                            .gallery,
                                      ),
                                    if (companyDetails.menu.length > 0)
                                      Tab(
                                        text: AppLocalizations.of(context).menu,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            (companyDetails.pictures.length > 0 &&
                                    companyDetails.branches.length > 0 &&
                                    companyDetails.menu.length > 0)
                                ? Expanded(
                                    child: TabBarView(
                                      children: [
                                        Container(
                                          child: CompanyDetailsInfoScreen(
                                              companyDetails: companyDetails),
                                        ),
                                        Container(
                                          child: CompanyDetailsBranchesScreen(
                                            branches: companyDetails.branches,
                                          ),
                                        ),
                                        Container(
                                          child: CompanyDetailsGalleryScreen(
                                            photos: companyDetails.pictures,
                                          ),
                                        ),
                                        Container(
                                          child: CompanyDetailsGalleryScreen(
                                            photos: companyDetails.menu,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : companyDetails.pictures.length > 0 &&
                                        companyDetails.branches.length > 0
                                    ? Expanded(
                                        child: TabBarView(
                                          children: [
                                            Container(
                                              child: CompanyDetailsInfoScreen(
                                                  companyDetails:
                                                      companyDetails),
                                            ),
                                            Container(
                                              child:
                                                  CompanyDetailsBranchesScreen(
                                                branches:
                                                    companyDetails.branches,
                                              ),
                                            ),
                                            Container(
                                              child:
                                                  CompanyDetailsGalleryScreen(
                                                photos: companyDetails.pictures,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : companyDetails.pictures.length > 0 &&
                                            companyDetails.menu.length > 0
                                        ? Expanded(
                                            child: TabBarView(
                                              children: [
                                                Container(
                                                  child:
                                                      CompanyDetailsInfoScreen(
                                                          companyDetails:
                                                              companyDetails),
                                                ),
                                                Container(
                                                  child:
                                                      CompanyDetailsGalleryScreen(
                                                    photos:
                                                        companyDetails.pictures,
                                                  ),
                                                ),
                                                Container(
                                                  child:
                                                      CompanyDetailsGalleryScreen(
                                                    photos: companyDetails.menu,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : companyDetails.branches.length > 0 &&
                                                companyDetails.menu.length > 0
                                            ? Expanded(
                                                child: TabBarView(
                                                  children: [
                                                    Container(
                                                      child:
                                                          CompanyDetailsInfoScreen(
                                                              companyDetails:
                                                                  companyDetails),
                                                    ),
                                                    Container(
                                                      child:
                                                          CompanyDetailsBranchesScreen(
                                                        branches: companyDetails
                                                            .branches,
                                                      ),
                                                    ),
                                                    Container(
                                                      child:
                                                          CompanyDetailsGalleryScreen(
                                                        photos:
                                                            companyDetails.menu,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : companyDetails.branches.length > 0
                                                ? Expanded(
                                                    child: TabBarView(
                                                      children: [
                                                        Container(
                                                          child: CompanyDetailsInfoScreen(
                                                              companyDetails:
                                                                  companyDetails),
                                                        ),
                                                        Container(
                                                          child:
                                                              CompanyDetailsBranchesScreen(
                                                            branches:
                                                                companyDetails
                                                                    .branches,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : companyDetails
                                                            .pictures.length >
                                                        0
                                                    ? Expanded(
                                                        child: TabBarView(
                                                          children: [
                                                            Container(
                                                              child: CompanyDetailsInfoScreen(
                                                                  companyDetails:
                                                                      companyDetails),
                                                            ),
                                                            Container(
                                                              child:
                                                                  CompanyDetailsGalleryScreen(
                                                                photos:
                                                                    companyDetails
                                                                        .pictures,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    : companyDetails
                                                                .menu.length >
                                                            0
                                                        ? Expanded(
                                                            child: TabBarView(
                                                              children: [
                                                                Container(
                                                                  child: CompanyDetailsInfoScreen(
                                                                      companyDetails:
                                                                          companyDetails),
                                                                ),
                                                                Container(
                                                                  child:
                                                                      CompanyDetailsGalleryScreen(
                                                                    photos:
                                                                        companyDetails
                                                                            .menu,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : Expanded(
                                                            child: Container(
                                                              child: CompanyDetailsInfoScreen(
                                                                  companyDetails:
                                                                      companyDetails),
                                                            ),
                                                          ),
                          ],
                        ),
                      ),
                    ),
                  )
                : state is CompanyDetailsErrorState
                    ? Scaffold(
                        body: ServerErrorWidget(
                          onTap: () =>
                              BlocProvider.of<CompanyDetailsBloc>(context).add(
                                  CompanyDetailsFetchEvent(
                                      id: widget.companyId)),
                        ),
                      )
                    : Scaffold(body: LoadingWidget());
          },
        ),
      ),
    );
  }
}
