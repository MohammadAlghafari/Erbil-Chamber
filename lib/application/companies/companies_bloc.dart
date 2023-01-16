import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../infrastructure/api/response_type.dart' as ResType;
import '../../infrastructure/catalog_facade_service.dart';
import '../../infrastructure/common_response/category_response.dart';
import '../../infrastructure/common_response/company_response.dart';

part 'companies_event.dart';
part 'companies_state.dart';

const _itemsLimit = 10;

class CompaniesBloc extends Bloc<CompaniesEvent, CompaniesState> {
  CompaniesBloc({@required this.catalogService})
      : assert(catalogService != null),
        super(CompaniesState());

  final CatalogFacadeService catalogService;

  @override
  Stream<CompaniesState> mapEventToState(
    CompaniesEvent event,
  ) async* {
    if (event is CompaniesSubCategoriesFetchEvent) {
      if (event.newRequest)
        yield state.copyWith(
            categoriesStatus: CategoriesStatus.initial,
            companiesStatus: CompaniesStatus.initial);
      yield await _mapCompaniesSubCategoriesFetchedToState(state, event);
    } else if (event is CompaniesFetchEvent) {
      yield* _mapCompaniesFetchedToState(state, event);
    } else if (event is CompaniesRefreshEvent) {
      if (event.newRequest)
        yield state.copyWith(companiesStatus: CompaniesStatus.initial);
      yield await _mapCompaniesRefreshedToState(state, event);
    }
  }

  Future<CompaniesState> _mapCompaniesRefreshedToState(
      CompaniesState state, CompaniesRefreshEvent event) async {
    try {
      final companies = await _fetchCompanies(
        event.parentCategories,
      );
      return state.copyWith(
        companiesStatus: CompaniesStatus.success,
        companies: companies,
        companiesHasReachedMax: _hasReachedMax(companies.length),
      );
    } catch (e) {
      return state.copyWith(companiesStatus: CompaniesStatus.failure);
    }
  }

  Stream<CompaniesState> _mapCompaniesFetchedToState(
      CompaniesState state, CompaniesFetchEvent event) async* {
    state = state.copyWith(
      selectedSubCategoryIndex: event.selectedSubCategoryIndex,
      companies: [],
      companiesStatus: CompaniesStatus.initial,
      categoriesStatus: CategoriesStatus.success,
      companiesHasReachedMax: false,
    );
    yield state;
    if (state.companiesHasReachedMax) return;
    try {
      if (state.companiesStatus == CompaniesStatus.initial) {
        final companies = await _fetchCompanies(event.parentCategories);
        yield state.copyWith(
          companiesStatus: CompaniesStatus.success,
          companies: companies,
          companiesHasReachedMax: _hasReachedMax(companies.length),
        );
        return;
      }
      final companies = await _fetchCompanies(event.parentCategories,
          (state.companies.length / _itemsLimit).round());
      yield companies.isEmpty
          ? state.copyWith(companiesHasReachedMax: true)
          : state.copyWith(
              categoriesStatus: CategoriesStatus.success,
              companies: List.of(state.companies)..addAll(companies),
              companiesHasReachedMax: _hasReachedMax(companies.length),
            );
    } catch (e) {
      yield state.copyWith(companiesStatus: CompaniesStatus.failure);
    }
  }

  Future<CompaniesState> _mapCompaniesSubCategoriesFetchedToState(
      CompaniesState state, CompaniesSubCategoriesFetchEvent event) async {
    if (state.categoriesHasReachedMax) return state;
    try {
      if (state.categoriesStatus == CategoriesStatus.initial) {
        final categories = await _fetchSubCategories(event.parentId);
        return state.copyWith(
          categoriesStatus: CategoriesStatus.initialSuccess,
          categories: categories,
          categoriesHasReachedMax: _hasReachedMax(categories.length),
        );
      }
      final categories = await _fetchSubCategories(
          event.parentId, (state.categories.length / _itemsLimit).round());
      return categories.isEmpty
          ? state.copyWith(categoriesHasReachedMax: true)
          : state.copyWith(
              categoriesStatus: CategoriesStatus.success,
              categories: List.of(state.categories)..addAll(categories),
              categoriesHasReachedMax: _hasReachedMax(categories.length),
            );
    } catch (e) {
      return state.copyWith(categoriesStatus: CategoriesStatus.failure);
    }
  }

  // ignore: missing_return
  Future<List<CategoryResponse>> _fetchSubCategories(String parentId,
      [int startIndex = 1]) async {
    try {
      final response = await catalogService.getCategorySubCategories(
        page: startIndex,
        size: _itemsLimit,
        parentId: parentId,
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
      throw Exception('error fetching subcategories');
    } on Exception catch (_) {}
  }

  // ignore: missing_return
  Future<List<CompanyResponse>> _fetchCompanies(
      List<String> parentCategoriesIds,
      [int startIndex = 1]) async {
    try {
      final response = await catalogService.getCompanies(
        page: startIndex,
        size: _itemsLimit,
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
