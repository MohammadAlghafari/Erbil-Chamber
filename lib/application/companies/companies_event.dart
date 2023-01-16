part of 'companies_bloc.dart';

abstract class CompaniesEvent extends Equatable {
  const CompaniesEvent();

  @override
  List<Object> get props => [];
}

class CompaniesSubCategoriesFetchEvent extends CompaniesEvent {
  const CompaniesSubCategoriesFetchEvent(
      {@required this.parentId, @required this.newRequest});
  final String parentId;
  final bool newRequest;
}

class CompaniesFetchEvent extends CompaniesEvent {
  const CompaniesFetchEvent(
      {@required this.parentCategories,
      @required this.selectedSubCategoryIndex});
  final List<String> parentCategories;
  final int selectedSubCategoryIndex;
}

class CompaniesRefreshEvent extends CompaniesEvent {
  const CompaniesRefreshEvent(
      {@required this.parentCategories, this.newRequest});
  final List<String> parentCategories;
  final bool newRequest;
}
