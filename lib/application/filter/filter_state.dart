part of 'filter_bloc.dart';

class FilterState extends Equatable {
  const FilterState();

  @override
  List<Object> get props => [];
}

class FilterLoadingState extends FilterState {}

class GetCategoriesSuccess extends FilterState {
  GetCategoriesSuccess({@required this.categories});
  final List<CategoryResponse> categories;
}

class GetSubCategoriesSuccess extends FilterState {
  GetSubCategoriesSuccess({@required this.subCategories});
  final List<CategoryResponse> subCategories;
}

class GetDistrictsSuccess extends FilterState {
  GetDistrictsSuccess({@required this.cities});
  final List<CityResponse> cities;
}
