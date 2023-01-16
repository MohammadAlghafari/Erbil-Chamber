part of 'favorite_bloc.dart';

enum FavoriteCompaniesStatus { initial, success, failure, loadingData }

@immutable
class FavoriteState /* extends Equatable */ {
  const FavoriteState({
    this.status = FavoriteCompaniesStatus.initial,
    this.companies = const <CompanyResponse>[],
    this.hasReachedMax = false,
  });

  final FavoriteCompaniesStatus status;
  final List<CompanyResponse> companies;
  final bool hasReachedMax;

  FavoriteState copyWith({
    FavoriteCompaniesStatus status,
    List<CompanyResponse> companies,
    bool hasReachedMax,
  }) {
    return FavoriteState(
      status: status ?? this.status,
      companies: companies ?? this.companies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  /* @override
  List<Object> get props => [status, companies, hasReachedMax]; */
}
