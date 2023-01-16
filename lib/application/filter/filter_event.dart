part of 'filter_bloc.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object> get props => [];
}

class FilterCategoriesFetchEvent extends FilterEvent {}

class FilterSubCategoriesFetchEvent extends FilterEvent {
  FilterSubCategoriesFetchEvent({@required this.categoryId});
  final String categoryId;
}

class FilterDistrictsFetchEvent extends FilterEvent {}
