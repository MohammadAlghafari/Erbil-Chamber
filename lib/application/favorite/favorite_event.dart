part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class FavoriteCompaniesFetchEvent extends FavoriteEvent {}

class FavoriteCompaniesRefreshEvent extends FavoriteEvent {
  FavoriteCompaniesRefreshEvent({@required this.newRefresh});
  final bool newRefresh;
}

class RefreshFavoriteEvent extends FavoriteEvent {
  RefreshFavoriteEvent({@required this.companyId});
  final String companyId;
}
