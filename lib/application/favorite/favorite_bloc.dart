import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/pref_keys.dart';
import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/common_response/company_response.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

const _itemsLimit = 20;

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(FavoriteState());

  final CatalogFacadeService catalogService;
  List<String> favoriteIds = [];

  @override
  Stream<FavoriteState> mapEventToState(
    FavoriteEvent event,
  ) async* {
    if (event is FavoriteCompaniesFetchEvent) {
      if (await _checkForFavorites())
        yield await _mapFavoriteFetchedToState(state, favoriteIds);
      else
        yield state.copyWith(status: FavoriteCompaniesStatus.success);
    } else if (event is FavoriteCompaniesRefreshEvent) {
      if (event.newRefresh)
        yield state.copyWith(status: FavoriteCompaniesStatus.initial);
      if (await _checkForFavorites()) {
        yield await _mapFavoriteRefreshedToState(state, favoriteIds);
      } else {
        await Future.delayed(Duration(seconds: 1));
        yield state.copyWith(status: FavoriteCompaniesStatus.success);
      }
    } else if (event is RefreshFavoriteEvent) {
      yield* _mapRefreshFavoriteToState(state, event);
    }
  }

  Stream<FavoriteState> _mapRefreshFavoriteToState(
      FavoriteState state, RefreshFavoriteEvent event) async* {
    state.companies.removeWhere((element) => element.id == event.companyId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String map = prefs.getString(PrefsKeys.FAVORITE_MAP);
    if (map != null) {
      Map<String, dynamic> favoriteMap = jsonDecode(map);
      favoriteMap.update(event.companyId, (value) => value = false);
      prefs.setString(PrefsKeys.FAVORITE_MAP, jsonEncode(favoriteMap));
    }
    favoriteIds.removeWhere((element) => element == event.companyId);
    yield state.copyWith(
      companies: state.companies,
    );
  }

  Future<FavoriteState> _mapFavoriteRefreshedToState(
      FavoriteState state, List<String> favoriteIds) async {
    try {
      final companies = await _fetchFavoriteCompanies(
        favoriteIds,
      );
      return state.copyWith(
        status: FavoriteCompaniesStatus.success,
        companies: companies,
        hasReachedMax: _hasReachedMax(companies.length),
      );
    } catch (e) {
      return state.copyWith(status: FavoriteCompaniesStatus.failure);
    }
  }

  Future<FavoriteState> _mapFavoriteFetchedToState(
      FavoriteState state, List<String> favoriteIds) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == FavoriteCompaniesStatus.initial) {
        final companies = await _fetchFavoriteCompanies(favoriteIds);
        return state.copyWith(
          status: FavoriteCompaniesStatus.success,
          companies: companies,
          hasReachedMax: _hasReachedMax(companies.length),
        );
      }
      final companies = await _fetchFavoriteCompanies(
          favoriteIds, (state.companies.length / _itemsLimit).round());
      return companies.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: FavoriteCompaniesStatus.success,
              companies: List.of(state.companies)..addAll(companies),
              hasReachedMax: _hasReachedMax(companies.length),
            );
    } catch (e) {
      return state.copyWith(status: FavoriteCompaniesStatus.failure);
    }
  }

  // ignore: missing_return
  Future<List<CompanyResponse>> _fetchFavoriteCompanies(
      List<String> favoriteIds,
      [int startIndex = 1]) async {
    try {
      final response = await catalogService.getFavoriteCompanies(
        page: startIndex,
        size: _itemsLimit,
        favoriteCompaniesIds: favoriteIds,
      );
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          return response.data;
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
        case ResType.ResponseType.SERVER_ERROR:
        case ResType.ResponseType.CLIENT_ERROR:
        case ResType.ResponseType.NETWORK_ERROR:
      }
      throw Exception('error fetching companies');
    } on Exception catch (_) {}
  }

  bool _hasReachedMax(int postsCount) =>
      postsCount < _itemsLimit ? true : false;

  Future<bool> _checkForFavorites() async {
    favoriteIds = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String map = prefs.getString(PrefsKeys.FAVORITE_MAP);
    if (map != null) {
      Map<String, dynamic> favoriteMap = jsonDecode(map);
      favoriteMap.forEach((key, value) {
        if (value) favoriteIds.add(key);
      });
    }
    if (favoriteIds.length > 0)
      return true;
    else
      return false;
  }
}
