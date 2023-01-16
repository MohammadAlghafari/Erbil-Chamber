part of 'company_details_bloc.dart';

abstract class CompanyDetailsEvent extends Equatable {
  const CompanyDetailsEvent();

  @override
  List<Object> get props => [];
}

class CompanyDetailsFetchEvent extends CompanyDetailsEvent {
  const CompanyDetailsFetchEvent({
    @required this.id,
  });
  final String id;
}

class SwitchFavoriteEvent extends CompanyDetailsEvent {
  SwitchFavoriteEvent({this.commpanyId, this.map});
  final String commpanyId;
  final Map<String, dynamic> map;

  @override
  List<Object> get props => [commpanyId, map];
}
