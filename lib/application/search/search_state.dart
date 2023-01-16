part of 'search_bloc.dart';

enum CompaniesStatus { initial, success, failure, loadingData }

@immutable
class SearchState extends Equatable {
  const SearchState({
    this.status = CompaniesStatus.initial,
    this.companies = const <CompanyResponse>[],
    this.hasReachedMax = false,
  });

  final CompaniesStatus status;
  final List<CompanyResponse> companies;
  final bool hasReachedMax;

  SearchState copyWith({
    CompaniesStatus status,
    List<CompanyResponse> companies,
    bool hasReachedMax,
  }) {
    return SearchState(
      status: status ?? this.status,
      companies: companies ?? this.companies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [
        status,
        companies,
        hasReachedMax,
      ];
}
