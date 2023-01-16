import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../application/search/search_bloc.dart';
import '../../../injections.dart';
import '../../custom_widgets/bottom_loader.dart';
import '../../custom_widgets/company_item.dart';
import '../../custom_widgets/creation_aware_list_item.dart';
import '../../custom_widgets/loading_widget.dart';
import '../../custom_widgets/no_data_no_refresh_widget.dart';
import '../../custom_widgets/server_error_widget.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search_screen';
  SearchScreen({
    Key key,
    @required this.filterOptions,
  }) : super(key: key);

  final Map<String, dynamic> filterOptions;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchBloc searchBloc;
  String categoryId;
  String subCategoryId;
  String cityId;
  String textSearch;
  bool isAdvancedSearch;
  bool newRequest = true;

  @override
  void initState() {
    super.initState();
    searchBloc = serviceLocator<SearchBloc>();
    categoryId = widget.filterOptions['categoryId'];
    subCategoryId = widget.filterOptions['subCategoryId'];
    cityId = widget.filterOptions['cityId'];
    textSearch = widget.filterOptions['searchText'];
    isAdvancedSearch = widget.filterOptions['isAdvancedSearch'];
  }

  @override
  Widget build(BuildContext context) {
    if (newRequest) {
      searchBloc.add(SearchCompaniesFetchEvent(
        parentCategories: subCategoryId == ''
            ? categoryId == ''
                ? []
                : [categoryId]
            : [subCategoryId],
        cityId: cityId,
        searchTerm: textSearch,
      ));
      newRequest = false;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).results_of_your_search,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: BlocProvider(
        create: (context) => searchBloc,
        child: BlocListener<SearchBloc, SearchState>(
          listener: (context, state) {},
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              switch (state.status) {
                case CompaniesStatus.loadingData:
                  return LoadingWidget();
                case CompaniesStatus.failure:
                  return ServerErrorWidget();

                case CompaniesStatus.success:
                  if (state.companies.isEmpty) {
                    return NoDataNoRefreshWidget();
                  }
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return index >= state.companies.length
                          ? BottomLoader()
                          : CreationAwareListItem(
                              itemCreated: () {
                                if (index == state.companies.length - 1) {
                                  print('Company created at $index');
                                  searchBloc.add(SearchCompaniesFetchEvent(
                                    parentCategories: [subCategoryId],
                                    cityId: cityId,
                                    searchTerm: textSearch,
                                  ));
                                }
                              },
                              child: CompanyItem(
                                companyResponse: state.companies[index],
                              ));
                    },
                    itemCount: state.hasReachedMax
                        ? state.companies.length
                        : state.companies.length + 1,
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
}
