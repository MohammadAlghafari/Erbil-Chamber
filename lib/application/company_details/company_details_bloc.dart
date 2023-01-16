import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/pref_keys.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/api/response_wrapper.dart';
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/company_details/response/company_details_response.dart';

part 'company_details_event.dart';
part 'company_details_state.dart';

class CompanyDetailsBloc
    extends Bloc<CompanyDetailsEvent, CompanyDetailsState> {
  CompanyDetailsBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(CompanyDetailsState());

  final CatalogFacadeService catalogService;

  @override
  Stream<CompanyDetailsState> mapEventToState(
    CompanyDetailsEvent event,
  ) async* {
    if (event is CompanyDetailsFetchEvent) {
      yield* _mapFetchCompanyDetailsToState(event);
    } else if (event is SwitchFavoriteEvent) {
      yield* _mapSwitchFavoriteToState(event);
    }
  }

  Stream<CompanyDetailsState> _mapFetchCompanyDetailsToState(
    CompanyDetailsFetchEvent event,
  ) async* {
    yield LoadingCompanyDetailsState();
    try {
      final ResponseWrapper<CompanyDetailsResponse> companyDetailsResponse =
          await catalogService.getCompanyDetails(
        id: event.id,
      );
      switch (companyDetailsResponse.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield CompanyDetailsSuccessState(
              companyDetails: companyDetailsResponse.data);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
          break;
        case ResType.ResponseType.SERVER_ERROR:
        case ResType.ResponseType.CLIENT_ERROR:
        case ResType.ResponseType.NETWORK_ERROR:
          yield CompanyDetailsErrorState();
          break;
      }
    } on Exception catch (_) {}
  }

  Stream<CompanyDetailsState> _mapSwitchFavoriteToState(
    SwitchFavoriteEvent event,
  ) async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (event.map != null) {
      if (event.map[event.commpanyId] != null) {
        bool favorite = event.map[event.commpanyId];
        event.map[event.commpanyId] = !favorite;
        prefs.setString(PrefsKeys.FAVORITE_MAP, jsonEncode(event.map));
        yield SwitchFavoriteMessageState(favorite: !favorite);
      } else {
        Map<String, bool> newMap = {'${event.commpanyId}': true};
        event.map.addAll(newMap);
        prefs.setString(PrefsKeys.FAVORITE_MAP, jsonEncode(event.map));
        yield SwitchFavoriteMessageState(favorite: true);
      }
    } else {
      Map<String, bool> map = {'${event.commpanyId}': true};
      prefs.setString(PrefsKeys.FAVORITE_MAP, jsonEncode(map));
      yield SwitchFavoriteMessageState(favorite: true);
    }
  }
}
