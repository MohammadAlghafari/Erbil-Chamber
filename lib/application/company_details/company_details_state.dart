part of 'company_details_bloc.dart';

class CompanyDetailsState extends Equatable {
  const CompanyDetailsState();

  @override
  List<Object> get props => [];
}

class LoadingCompanyDetailsState extends CompanyDetailsState {}

class SwitchFavoriteMessageState extends CompanyDetailsState {
  SwitchFavoriteMessageState({this.favorite});
  final bool favorite;

  @override
  List<Object> get props => [favorite];
}

class CompanyDetailsSuccessState extends CompanyDetailsState {
  CompanyDetailsSuccessState({@required this.companyDetails});
  final CompanyDetailsResponse companyDetails;
}

class CompanyDetailsErrorState extends CompanyDetailsState {}
