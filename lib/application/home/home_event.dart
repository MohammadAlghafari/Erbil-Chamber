part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeDataFetchEvent extends HomeEvent {}

class HomeCategoriesFetchEvent extends HomeEvent {}

class HomeCategoriesRefreshEvent extends HomeEvent {
  HomeCategoriesRefreshEvent({this.newRefresh});
  final bool newRefresh;
}
