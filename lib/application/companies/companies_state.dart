part of 'companies_bloc.dart';

enum CategoriesStatus { initial, initialSuccess, success, failure, loadingData }
enum CompaniesStatus { initial, success, failure, loadingData }

@immutable
class CompaniesState extends Equatable {
  const CompaniesState({
    this.selectedSubCategoryIndex = 0,
    this.categoriesStatus = CategoriesStatus.initial,
    this.companiesStatus = CompaniesStatus.initial,
    this.categories = const <CategoryResponse>[],
    this.companies = const <CompanyResponse>[],
    this.categoriesHasReachedMax = false,
    this.companiesHasReachedMax = false,
  });

  final int selectedSubCategoryIndex;
  final CategoriesStatus categoriesStatus;
  final CompaniesStatus companiesStatus;
  final List<CategoryResponse> categories;
  final List<CompanyResponse> companies;
  final bool categoriesHasReachedMax;
  final bool companiesHasReachedMax;

  CompaniesState copyWith({
    int selectedSubCategoryIndex,
    CategoriesStatus categoriesStatus,
    CompaniesStatus companiesStatus,
    List<CategoryResponse> categories,
    List<CompanyResponse> companies,
    bool categoriesHasReachedMax,
    bool companiesHasReachedMax,
  }) {
    return CompaniesState(
      selectedSubCategoryIndex:
          selectedSubCategoryIndex ?? this.selectedSubCategoryIndex,
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
      companiesStatus: companiesStatus ?? this.companiesStatus,
      categories: categories ?? this.categories,
      companies: companies ?? this.companies,
      categoriesHasReachedMax:
          categoriesHasReachedMax ?? this.categoriesHasReachedMax,
      companiesHasReachedMax:
          companiesHasReachedMax ?? this.companiesHasReachedMax,
    );
  }

  @override
  List<Object> get props => [
        selectedSubCategoryIndex,
        categoriesStatus,
        companiesStatus,
        categories,
        companies,
        categoriesHasReachedMax,
        companiesHasReachedMax,
      ];
}

