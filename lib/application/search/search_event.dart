part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchCompaniesFetchEvent extends SearchEvent{
  const SearchCompaniesFetchEvent({
    @required this.parentCategories,
    @required this.cityId,
    @required this.searchTerm,
  });
  final List<String> parentCategories;
  final String cityId;
  final String searchTerm;
}
