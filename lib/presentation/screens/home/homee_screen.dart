import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../application/home/home_bloc.dart';
import '../../../common/global_purpose_functions.dart';
import '../../../infrastructure/api/urls.dart';
import '../../../injections.dart';
import '../../custom_widgets/bottom_loader.dart';
import '../../custom_widgets/category_list_item.dart';
import '../../custom_widgets/creation_aware_list_item.dart';
import '../../custom_widgets/languages_dialog.dart';
import '../../custom_widgets/loading_widget.dart';
import '../../custom_widgets/no_data_no_refresh_widget.dart';
import '../../custom_widgets/no_data_widget.dart';
import '../../custom_widgets/server_error_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc homeBloc;

  @override
  void initState() {
    super.initState();
    homeBloc = serviceLocator<HomeBloc>();
    homeBloc.add(HomeDataFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        /* appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context).erbil_chamber,
            style: TextStyle(color: Colors.black, fontSize: 22),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => LanguagesDialog());
                })
          ],
        ), */
        body: Stack(
          children: [
            Container(
              color: Colors.indigo,
            ),
            Container(
              margin: EdgeInsets.only(top: 300),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(50),
                  )),
            ),
            PositionedDirectional(
              end: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    icon: Icon(
                      Icons.settings,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => LanguagesDialog());
                    }),
              ),
            ),
            BlocProvider(
              create: (context) => homeBloc,
              child: BlocListener<HomeBloc, HomeState>(
                listener: (context, state) {},
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case CategoriesStatus.failure:
                        return ServerErrorWidget(
                          onTap: () => _refreshData(context, true),
                        );
                      case CategoriesStatus.success:
                        if (state.categories.isEmpty) {
                          return NoDataWidget(
                            onTap: () => _refreshData(context, true),
                          );
                        }
                        return RefreshIndicator(
                          onRefresh: () async {
                            _refreshData(context, false);
                          },
                          child: Column(
                            children: [
                              state.ads.length > 0
                                  ? Container(
                                      margin: EdgeInsets.only(top: 55),
                                      child: CarouselSlider.builder(
                                        itemCount: state.ads.length,
                                        itemBuilder: (BuildContext context,
                                                int itemIndex, _) =>
                                            GestureDetector(
                                          onTap: () {
                                            GlobalPurposeFunctions.launchURL(
                                                url: state.ads[itemIndex]
                                                    .externalURL);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(5.0),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0)),
                                              child: Center(
                                                child: CachedNetworkImage(
                                                  imageUrl: Urls.BASE_URL +
                                                      state.ads[itemIndex]
                                                          .picture.lg
                                                          .substring(1),
                                                  fit: BoxFit.cover,
                                                  width: 1000,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        options: CarouselOptions(
                                          aspectRatio: 26 / 9,
                                          autoPlay: true,
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          enlargeCenterPage: true,
                                        ),
                                      ),
                                    )
                                  : NoDataNoRefreshWidget(),
                              SizedBox(height: 10),
                              Center(
                                child: Text(
                                  AppLocalizations.of(context).categories,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Expanded(
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 0.8,
                                  ),
                                  itemBuilder: (context, index) {
                                    return index >= state.categories.length
                                        ? BottomLoader()
                                        : CreationAwareListItem(
                                            itemCreated: () {
                                              if (index ==
                                                  state.categories.length - 1) {
                                                print(
                                                    'Category created at $index');
                                                homeBloc.add(
                                                    HomeCategoriesFetchEvent());
                                              }
                                            },
                                            child: CategoryListItem(
                                              category: state.categories[index],
                                            ),
                                          );
                                  },
                                  itemCount: state.hasReachedMax
                                      ? state.categories.length
                                      : state.categories.length + 1,
                                  shrinkWrap: true,
                                ),
                              ),
                            ],
                          ),
                        );
                      default:
                        return LoadingWidget();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _refreshData(BuildContext context, bool newRefresh) {
    BlocProvider.of<HomeBloc>(context)
        .add(HomeCategoriesRefreshEvent(newRefresh: newRefresh));
  }
}
