part of 'near_by_bloc.dart';

abstract class NearByEvent extends Equatable {
  const NearByEvent();

  @override
  List<Object> get props => [];
}

class NearByCompaniesFetchEvent extends NearByEvent {
  NearByCompaniesFetchEvent({this.refresh = false});
  final bool refresh;
}
class NearByTabChangedEvent extends NearByEvent {
  NearByTabChangedEvent({this.pageNumber});
  final int pageNumber;
}
