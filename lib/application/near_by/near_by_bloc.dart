import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../common/global_purpose_functions.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/common_response/company_response.dart';

part 'near_by_event.dart';
part 'near_by_state.dart';

class NearByBloc extends Bloc<NearByEvent, NearByState> {
  NearByBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(NearByState());

  final CatalogFacadeService catalogService;

  @override
  Stream<NearByState> mapEventToState(
    NearByEvent event,
  ) async* {
    if (event is NearByCompaniesFetchEvent) {
      yield* _mapNearByCompaniesFetchedToState(event);
    } else if (event is NearByTabChangedEvent) {
      yield NearByTabChangedState(pageNumber: event.pageNumber);
    }
  }

  Stream<NearByState> _mapNearByCompaniesFetchedToState(
      NearByCompaniesFetchEvent event) async* {
    if (!event.refresh) yield LoadingNearByState();
    try {
      Position deviceLocation =
          await GlobalPurposeFunctions.getdevicePosition();
      final response = await catalogService.getNearByCompanies(
          latitude: deviceLocation.latitude,
          longitude: deviceLocation.longitude);
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield NearByCompaniesFetchedState(
              nearByCompanies: response.data, deviceLocation: deviceLocation);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
        case ResType.ResponseType.SERVER_ERROR:
        case ResType.ResponseType.CLIENT_ERROR:
        case ResType.ResponseType.NETWORK_ERROR:
      }
    } on Exception catch (_) {
      yield ErrorNearByState();
    }
  }
}
