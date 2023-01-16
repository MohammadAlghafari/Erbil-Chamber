part of 'near_by_bloc.dart';

class NearByState extends Equatable {
  const NearByState();

  @override
  List<Object> get props => [];
}

class LoadingNearByState extends NearByState {}

class ErrorNearByState extends NearByState {}

class NearByTabChangedState extends NearByState {
  NearByTabChangedState({this.pageNumber});
  final int pageNumber;
  @override
  List<Object> get props => [pageNumber];
}

class NearByCompaniesFetchedState extends NearByState {
  NearByCompaniesFetchedState({this.nearByCompanies, this.deviceLocation});
  final List<CompanyResponse> nearByCompanies;
  final Position deviceLocation;

  @override
  List<Object> get props => [nearByCompanies, deviceLocation];
}
