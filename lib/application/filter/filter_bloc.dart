import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/common_response/category_response.dart';
import '../../infrastructure/common_response/city_response.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(FilterState());

  final CatalogFacadeService catalogService;

  @override
  Stream<FilterState> mapEventToState(
    FilterEvent event,
  ) async* {
    if (event is FilterCategoriesFetchEvent) {
      yield* _mapFilterCategoriesToState();
    } else if (event is FilterSubCategoriesFetchEvent) {
      yield* _mapFilterSubCategoriesToState(event);
    } else if (event is FilterDistrictsFetchEvent) {
      yield* _mapFilterDistrictsToState();
    }
  }

  Stream<FilterState> _mapFilterCategoriesToState() async* {
    yield FilterLoadingState();
    try {
      final response = await catalogService.getFilterCategories(
        mainPage: true,
      );
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield GetCategoriesSuccess(categories: response.data);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
        case ResType.ResponseType.SERVER_ERROR:
        case ResType.ResponseType.CLIENT_ERROR:
        case ResType.ResponseType.NETWORK_ERROR:
      }
      throw Exception('error fetching categories');
    } on Exception catch (_) {}
  }

  Stream<FilterState> _mapFilterSubCategoriesToState(
    FilterSubCategoriesFetchEvent event,
  ) async* {
    yield FilterLoadingState();
    try {
      final response = await catalogService.getFilterSubCategories(
        parentId: event.categoryId,
      );
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield GetSubCategoriesSuccess(subCategories: response.data);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
        case ResType.ResponseType.SERVER_ERROR:
        case ResType.ResponseType.CLIENT_ERROR:
        case ResType.ResponseType.NETWORK_ERROR:
      }
      throw Exception('error fetching subCategories');
    } on Exception catch (_) {}
  }

  Stream<FilterState> _mapFilterDistrictsToState() async* {
    yield FilterLoadingState();
    try {
      final response = await catalogService.getFilterCities();
      switch (response.responseType) {
        case ResType.ResponseType.SUCCESS:
          yield GetDistrictsSuccess(cities: response.data);
          break;
        case ResType.ResponseType.VALIDATION_ERROR:
        case ResType.ResponseType.SERVER_ERROR:
        case ResType.ResponseType.CLIENT_ERROR:
        case ResType.ResponseType.NETWORK_ERROR:
      }
      throw Exception('error fetching districts');
    } on Exception catch (_) {}
  }
}
