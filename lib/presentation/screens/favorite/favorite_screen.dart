import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../application/favorite/favorite_bloc.dart';
import '../../../injections.dart';
import '../../custom_widgets/bottom_loader.dart';
import '../../custom_widgets/creation_aware_list_item.dart';
import '../../custom_widgets/favorite_company_item.dart';
import '../../custom_widgets/loading_widget.dart';
import '../../custom_widgets/no_data_widget.dart';
import '../../custom_widgets/server_error_widget.dart';

class FavoriteScreen extends StatefulWidget {
  FavoriteScreen({Key key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  FavoriteBloc favoriteBloc;

  @override
  void initState() {
    super.initState();
    favoriteBloc = serviceLocator<FavoriteBloc>();
    favoriteBloc.add(FavoriteCompaniesFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 1.0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).favorite,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: BlocProvider(
        create: (context) => favoriteBloc,
        child: BlocListener<FavoriteBloc, FavoriteState>(
          listener: (context, state) {},
          child: BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              switch (state.status) {
                case FavoriteCompaniesStatus.loadingData:
                  return LoadingWidget();
                case FavoriteCompaniesStatus.failure:
                  return ServerErrorWidget(
                    onTap: () => _refreshData(context, true),
                  );
                case FavoriteCompaniesStatus.success:
                  if (state.companies.isEmpty) {
                    return NoDataWidget(
                      onTap: () => _refreshData(context, true),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      _refreshData(context, false);
                    },
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return index >= state.companies.length
                            ? BottomLoader()
                            : Container(
                                margin:
                                    EdgeInsets.only(top: index == 0 ? 5 : 0),
                                child: CreationAwareListItem(
                                    itemCreated: () {
                                      if (index == state.companies.length - 1) {
                                        print('Company created at $index');
                                        favoriteBloc
                                            .add(FavoriteCompaniesFetchEvent());
                                      }
                                    },
                                    child: FavoriteCompanyItem(
                                      companyResponse: state.companies[index],
                                      updateView: (companyId) {
                                        BlocProvider.of<FavoriteBloc>(context)
                                            .add(RefreshFavoriteEvent(
                                                companyId: companyId));
                                      },
                                    )),
                              );
                      },
                      itemCount: state.hasReachedMax
                          ? state.companies.length
                          : state.companies.length + 1,
                    ),
                  );
                default:
                  return LoadingWidget();
              }
            },
          ),
        ),
      ),
    );
  }

  _refreshData(BuildContext context, bool newRefresh) {
    BlocProvider.of<FavoriteBloc>(context)
        .add(FavoriteCompaniesRefreshEvent(newRefresh: newRefresh));
  }
}
