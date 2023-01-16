import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../application/filter/filter_bloc.dart';
import '../../common/global_purpose_functions.dart';
import '../../infrastructure/api/search_model.dart';
import '../../injections.dart';
import '../screens/search/search_screen.dart';
import 'dropdown_text_field.dart';
import 'search_dialog.dart';

class FilterCompaniesBottomSheet extends StatefulWidget {
  FilterCompaniesBottomSheet();

  @override
  State<StatefulWidget> createState() {
    return _FilterCompaniesBottomSheet();
  }
}

class _FilterCompaniesBottomSheet extends State<FilterCompaniesBottomSheet> {
  FilterBloc filterBloc;
  TextEditingController _mainCategoryController = TextEditingController();
  TextEditingController _subCategoryController = TextEditingController();
  TextEditingController _districtController = TextEditingController();
  List<SearchModel> searchedList = [];
  String categoryId = "";
  String subCategoryId = "";
  String districtId = "";

  @override
  void initState() {
    super.initState();
    filterBloc = serviceLocator<FilterBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FilterBloc>(
      create: (context) => filterBloc,
      child: BlocListener<FilterBloc, FilterState>(
        listener: (context, state) {
          if (state is FilterLoadingState) {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, true);
          } else if (state is GetSubCategoriesSuccess) {
            _handleGetAdvanceSearchSubCategorySuccess(state);
          } else if (state is GetCategoriesSuccess) {
            _handleGetAdvanceSearchMainCategorySucces(state);
          } else if (state is GetDistrictsSuccess) {
            _handleGetAdvanceSearchCitiesSuccess(state);
          } else {
            GlobalPurposeFunctions.showOrHideProgressDialog(context, false);
            GlobalPurposeFunctions.showToast(
              'Check your internet connection',
              context,
            );
          }
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Colors.white),
            child: Wrap(
              children: [
                Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          AppLocalizations.of(context).advanced_search,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 10),
                        mainCategory(context),
                        SizedBox(height: 10),
                        subCategories(context),
                        SizedBox(height: 10),
                        city(context),
                        SizedBox(height: 20),
                        resetAndSearchButton(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleResetAdvanceSearchValuesState() {
    _mainCategoryController.text = "";
    _subCategoryController.text = "";
    _districtController.text = "";
    categoryId = "";
    subCategoryId = "";
    districtId = "";
  }

  void _handleGetAdvanceSearchMainCategorySucces(GetCategoriesSuccess state) {
    GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
        .then((value) {
      searchedList.clear();
      for (var i = 0; i < state.categories.length; i++) {
        searchedList.add(SearchModel(
            id: state.categories[i].id, name: state.categories[i].name));
      }
      showDialog(
          context: context,
          builder: (context) => SearchDialog(
                data: searchedList,
              )).then((val) {
        if (val != null) {
          categoryId = state.categories[val].id;
          _mainCategoryController.text = state.categories[val].name;
        }
      });
    });
  }

  void _handleGetAdvanceSearchSubCategorySuccess(
      GetSubCategoriesSuccess state) {
    GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
        .then((value) {
      searchedList.clear();
      for (var i = 0; i < state.subCategories.length; i++) {
        searchedList.add(SearchModel(
            id: state.subCategories[i].id, name: state.subCategories[i].name));
      }
      showDialog(
          context: context,
          builder: (context) => SearchDialog(
                data: searchedList,
              )).then((val) {
        if (val != null) {
          subCategoryId = state.subCategories[val].id;
          _subCategoryController.text = state.subCategories[val].name;
        }
      });
    });
  }

  void _handleGetAdvanceSearchCitiesSuccess(GetDistrictsSuccess state) {
    GlobalPurposeFunctions.showOrHideProgressDialog(context, false)
        .then((value) {
      searchedList.clear();
      for (var i = 0; i < state.cities.length; i++) {
        searchedList.add(
            SearchModel(id: state.cities[i].id, name: state.cities[i].name));
      }
      showDialog(
          context: context,
          builder: (context) => SearchDialog(
                data: searchedList,
              )).then((val) {
        if (val != null) {
          districtId = state.cities[val].id;
          _districtController.text = state.cities[val].name;
        }
      });
    });
  }

  Widget resetAndSearchButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: TextButton(
            onPressed: _handleResetAdvanceSearchValuesState,
            style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).accentColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  flex: 2,
                  child: Text(
                    AppLocalizations.of(context).reset,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Icon(
                    Icons.settings_backup_restore,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextButton(
            onPressed: () {
              Map<String, dynamic> params = {
                'categoryId': categoryId,
                'subCategoryId': subCategoryId,
                'cityId': districtId,
                'isAdvanceSearch': true,
                "searchText": ''
              };
              Navigator.of(context)
                  .pushNamed(SearchScreen.routeName, arguments: params);
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).accentColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Text(
                    AppLocalizations.of(context).search,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget city(BuildContext context) {
    return DropDownTextField(
      hintText: AppLocalizations.of(context).district,
      controller: _districtController,
      errorText: null,
      handleTap: () {
        filterBloc.add(FilterDistrictsFetchEvent());
      },
    );
  }

  Widget subCategories(BuildContext context) {
    return DropDownTextField(
      hintText: AppLocalizations.of(context).sub_category,
      controller: _subCategoryController,
      errorText: null,
      handleTap: () {
        _mainCategoryController.text.isEmpty
            ? GlobalPurposeFunctions.showToast(
                AppLocalizations.of(context).please_choose_category_first,
                context,
              )
            : filterBloc.add(FilterSubCategoriesFetchEvent(
                categoryId: categoryId,
              ));
      },
    );
  }

  Widget mainCategory(BuildContext context) {
    return DropDownTextField(
      hintText: AppLocalizations.of(context).main_category,
      controller: _mainCategoryController,
      errorText: null,
      handleTap: () {
        filterBloc.add(FilterCategoriesFetchEvent());
      },
    );
  }
}
