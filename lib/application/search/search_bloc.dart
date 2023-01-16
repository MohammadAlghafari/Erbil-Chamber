import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/common_response/company_response.dart';

part 'search_event.dart';
part 'search_state.dart';

const _itemsLimit = 20;

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(SearchState());

  final CatalogFacadeService catalogService;

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    if (event is SearchCompaniesFetchEvent) {
      yield await _mapSearchCompaniesFetchedToState(state, event);
    }
  }

  Future<SearchState> _mapSearchCompaniesFetchedToState(
    SearchState state,
    SearchCompaniesFetchEvent event,
  ) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == CompaniesStatus.initial) {
        final companies = await _fetchFavoriteCompanies(
          event.parentCategories,
          event.cityId,
          event.searchTerm,
        );
        return state.copyWith(
          status: CompaniesStatus.success,
          companies: companies,
          hasReachedMax: _hasReachedMax(companies.length),
        );
      }
      final companies = await _fetchFavoriteCompanies(
          event.parentCategories,
          event.cityId,
          event.searchTerm,
          (state.companies.length / _itemsLimit).round());
      return companies.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: CompaniesStatus.success,
              companies: List.of(state.companies)..addAll(companies),
              hasReachedMax: _hasReachedMax(companies.length),
            );
    } catch (e) {
      return state.copyWith(status: CompaniesStatus.failure);
    }
  }

  // ignore: missing_return
  Future<List<CompanyResponse>> _fetchFavoriteCompanies(
      List<String> parentCategoriesIds, String cityId, String searchTerm,
      [int startIndex = 1]) async {
    try {
      final response = await catalogService.getSearchCompanies(
        page: startIndex,
        size: _itemsLimit,
        searchTerm: searchTerm,
        cityId: cityId,
        parentCategoriesIds: parentCategoriesIds,
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
}
