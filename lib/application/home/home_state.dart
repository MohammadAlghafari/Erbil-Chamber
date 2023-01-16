part of 'home_bloc.dart';

enum CategoriesStatus { initial, success, failure, loadingData }

@immutable
class HomeState extends Equatable {
  const HomeState({
    this.status = CategoriesStatus.initial,
    this.categories = const <CategoryResponse>[],
    this.ads = const <AdResponse>[],
    this.hasReachedMax = false,
  });

  final CategoriesStatus status;
  final List<CategoryResponse> categories;
  final List<AdResponse> ads;
  final bool hasReachedMax;

  HomeState copyWith({
    CategoriesStatus status,
    List<CategoryResponse> categories,
    List<AdResponse> ads,
    bool hasReachedMax,
  }) {
    return HomeState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      ads: ads ?? this.ads,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [status, categories, ads, hasReachedMax];
}
