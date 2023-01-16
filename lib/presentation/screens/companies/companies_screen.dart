import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../application/companies/companies_bloc.dart';
import '../../../infrastructure/common_response/category_response.dart';
import '../../../infrastructure/common_response/picture_response.dart';
import '../../../injections.dart';
import '../../custom_widgets/bottom_loader.dart';
import '../../custom_widgets/company_item.dart';
import '../../custom_widgets/creation_aware_list_item.dart';
import '../../custom_widgets/filter_companies_bottom_sheet.dart';
import '../../custom_widgets/loading_widget.dart';
import '../../custom_widgets/no_data_widget.dart';
import '../../custom_widgets/server_error_widget.dart';
import '../../custom_widgets/sub_category_list_item.dart';
import '../search/search_screen.dart';

class CompaniesScreen extends StatefulWidget {
  CompaniesScreen({Key key, @required this.category}) : super(key: key);
  static const routeName = '/companies_screen';

  final CategoryResponse category;

  @override
  _CompaniesScreenState createState() => _CompaniesScreenState();
}

class _CompaniesScreenState extends State<CompaniesScreen> {
  CompaniesBloc companiesBloc;
  bool allCategoriesAdded = false;
  String selectdSubCategoryId;

  @override
  void initState() {
    super.initState();
    companiesBloc = serviceLocator<CompaniesBloc>();
    companiesBloc.add(CompaniesSubCategoriesFetchEvent(
      parentId: widget.category.id,
      newRequest: false,
    ));
    selectdSubCategoryId = widget.category.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          widget.category.name,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: BlocProvider(
        create: (context) => companiesBloc,
        child: BlocListener<CompaniesBloc, CompaniesState>(
          listener: (context, state) {
            if (state.categoriesStatus == CategoriesStatus.initialSuccess) {
              BlocProvider.of<CompaniesBloc>(context).add(CompaniesFetchEvent(
                  parentCategories: [widget.category.id],
                  selectedSubCategoryIndex: 0));
            }
          },
          child: BlocBuilder<CompaniesBloc, CompaniesState>(
            builder: (context, state) {
              switch (state.categoriesStatus) {
                case CategoriesStatus.failure:
                  return ServerErrorWidget(
                    onTap: () {
                      BlocProvider.of<CompaniesBloc>(context)
                          .add(CompaniesSubCategoriesFetchEvent(
                        parentId: widget.category.id,
                        newRequest: true,
                      ));
                    },
                  );
                case CategoriesStatus.initialSuccess:
                case CategoriesStatus.success:
                  if (state.categories.isEmpty) {
                    return NoDataWidget();
                  }
                  if (!allCategoriesAdded) {
                    state.categories.insert(
                        0,
                        CategoryResponse(
                            name: AppLocalizations.of(context).all,
                            order: 0,
                            parentId: null,
                            picture: PictureResponse(
                                lg: 'assets/svg/four_squares.svg',
                                md: 'assets/svg/four_squares.svg',
                                xs: 'assets/svg/four_squares.svg'),
                            id: '-1'));
                    allCategoriesAdded = true;
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      _refrshData(context, false);
                    },
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Container(
                                    child: TextField(
                                      onSubmitted: (searchText) {
                                        Map<String, dynamic> params = {
                                          'categoryId': '',
                                          'subCategoryId': '',
                                          'cityId': '',
                                          'isAdvancedSearch': false,
                                          "searchText": searchText,
                                        };
                                        Navigator.of(context).pushNamed(
                                            SearchScreen.routeName,
                                            arguments: params);
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(8),
                                        hintText: AppLocalizations.of(context)
                                            .search_for_company,
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .merge(TextStyle(fontSize: 14)),
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: Theme.of(context).primaryColor,
                                          size: 25,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .focusColor
                                                  .withOpacity(0.2)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .focusColor
                                                  .withOpacity(0.2)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) =>
                                            FilterCompaniesBottomSheet());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 5, left: 5),
                                    child: Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            stops: [0.1, 0.5, 0.7, 0.8, 0.9],
                                            colors: [
                                              Colors.indigo[800],
                                              Colors.indigo[700],
                                              Colors.indigo[600],
                                              Colors.indigo[400],
                                              Colors.indigo[300],
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Icon(Icons.filter_list,
                                          color: Theme.of(context).canvasColor),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 11,
                          ),
                          BlocBuilder<CompaniesBloc, CompaniesState>(
                              buildWhen: (previous, current) =>
                                  previous.categories.length !=
                                      current.categories.length ||
                                  previous.selectedSubCategoryIndex !=
                                      current.selectedSubCategoryIndex,
                              builder: (context, state) {
                                return Container(
                                  height: 150,
                                  child: ListView.builder(
                                    itemBuilder: (
                                      BuildContext context,
                                      int index,
                                    ) {
                                      return index >= state.categories.length
                                          ? BottomLoader()
                                          : CreationAwareListItem(
                                              itemCreated: () {
                                                if (index ==
                                                    state.categories.length -
                                                        1) {
                                                  print(
                                                      'SubCategory created at $index');
                                                  companiesBloc.add(
                                                      CompaniesSubCategoriesFetchEvent(
                                                    parentId:
                                                        widget.category.id,
                                                    newRequest: false,
                                                  ));
                                                }
                                              },
                                              child: SubCategoryListItem(
                                                subCategory:
                                                    state.categories[index],
                                                selected:
                                                    state.selectedSubCategoryIndex ==
                                                            index
                                                        ? true
                                                        : false,
                                                onTap: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  if (state
                                                          .selectedSubCategoryIndex !=
                                                      index) if (index == 0) {
                                                    BlocProvider.of<
                                                                CompaniesBloc>(
                                                            context)
                                                        .add(CompaniesFetchEvent(
                                                            parentCategories: [
                                                          widget.category.id,
                                                        ],
                                                            selectedSubCategoryIndex:
                                                                index));
                                                    selectdSubCategoryId =
                                                        widget.category.id;
                                                  } else {
                                                    BlocProvider.of<
                                                                CompaniesBloc>(
                                                            context)
                                                        .add(CompaniesFetchEvent(
                                                            parentCategories: [
                                                          state
                                                              .categories[index]
                                                              .id,
                                                        ],
                                                            selectedSubCategoryIndex:
                                                                index));
                                                    selectdSubCategoryId = state
                                                        .categories[index].id;
                                                  }
                                                },
                                              ),
                                            );
                                    },
                                    itemCount: state.categoriesHasReachedMax
                                        ? state.categories.length
                                        : state.categories.length + 1,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                  ),
                                );
                              }),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)
                                    .results_for_sub_category,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          BlocBuilder<CompaniesBloc, CompaniesState>(
                            builder: (context, state) {
                              switch (state.companiesStatus) {
                                case CompaniesStatus.failure:
                                  return const Center(
                                      child: ServerErrorWidget());
                                case CompaniesStatus.success:
                                  if (state.companies.isEmpty) {
                                    return NoDataWidget(
                                      onTap: () => _refrshData(context, true),
                                    );
                                  }
                                  return ListView.builder(
                                    itemBuilder: (
                                      BuildContext context,
                                      int i,
                                    ) =>
                                        CompanyItem(
                                      companyResponse: state.companies[i],
                                    ),
                                    itemCount: state.companies.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                  );
                                default:
                                  return LoadingWidget();
                              }
                            },
                          ),
                        ],
                      ),
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

  _refrshData(BuildContext context, bool newRequest) {
    BlocProvider.of<CompaniesBloc>(context).add(CompaniesRefreshEvent(
        parentCategories: [selectdSubCategoryId], newRequest: newRequest));
  }
}
