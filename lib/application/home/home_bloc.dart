import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/common_response/category_response.dart';
import '../../infrastructure/home/response/ad_response.dart';

part 'home_event.dart';
part 'home_state.dart';

const _categoriesLimit = 10;

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(HomeState());

  final CatalogFacadeService catalogService;

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is HomeDataFetchEvent) {
      yield* _mapHomeDataFetchedToState(state);
    } else if (event is HomeCategoriesFetchEvent) {
      yield await _mapHomeCategoriesFetchedToState(state);
    } else if (event is HomeCategoriesRefreshEvent) {
      if (event.newRefresh)
        yield state.copyWith(status: CategoriesStatus.initial);
      yield* _mapHomeDataFetchedToState(state);
    }
  }

  Stream<HomeState> _mapHomeDataFetchedToState(HomeState state) async* {
    try {
      final ads = await catalogService.getAds();
      switch (ads.responseType) {
        case ResType.ResponseType.SUCCESS:
          state = state.copyWith(
            ads: ads.data,
          );
          yield state;
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
        case ResType.ResponseType.SERVER_ERROR:
        case ResType.ResponseType.CLIENT_ERROR:
        case ResType.ResponseType.NETWORK_ERROR:
      }
      throw Exception('error fetching ads');
    } on Exception catch (_) {}
    yield await _mapHomeCategoriesFetchedToState(state);
  }

  /* Future<HomeState> _mapHomeCategoriesRefreshedToState(HomeState state) async {
    try {
      final categories = await _fetchCategories();
      return state.copyWith(
        status: CategoriesStatus.success,
        categories: categories,
        hasReachedMax: _hasReachedMax(categories.length),
      );
    } catch (e) {
      return state.copyWith(status: CategoriesStatus.failure);
    }
  } */

  Future<HomeState> _mapHomeCategoriesFetchedToState(HomeState state) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == CategoriesStatus.initial) {
        final categories = await _fetchCategories();
        return state.copyWith(
          status: CategoriesStatus.success,
          categories: categories,
          hasReachedMax: _hasReachedMax(categories.length),
        );
      }
      final categories = await _fetchCategories(
          (state.categories.length / _categoriesLimit).round());
      return categories.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: CategoriesStatus.success,
              categories: List.of(state.categories)..addAll(categories),
              hasReachedMax: _hasReachedMax(categories.length),
            );
    } catch (e) {
      return state.copyWith(status: CategoriesStatus.failure);
    }
  }

  // ignore: missing_return
  Future<List<CategoryResponse>> _fetchCategories([int startIndex = 1]) async {
    try {
      final response = await catalogService.getCategories(
        page: startIndex,
        size: _categoriesLimit,
        mainPage: true,
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
      throw Exception('error fetching categories');
    } on Exception catch (_) {}
  }

  bool _hasReachedMax(int categoriesCount) =>
      categoriesCount < _categoriesLimit ? true : false;
}
