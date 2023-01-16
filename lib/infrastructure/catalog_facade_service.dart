import 'package:flutter/material.dart';

import 'api/response_wrapper.dart';
import 'common_response/category_response.dart';
import 'common_response/city_response.dart';
import 'common_response/company_response.dart';
import 'companies/companies_repository.dart';
import 'company_details/company_details_repository.dart';
import 'company_details/response/company_details_response.dart';
import 'favorite/favorite_repository.dart';
import 'filter/filter_repository.dart';
import 'home/home_repository.dart';
import 'home/response/ad_response.dart';
import 'near_by/near_by_repository.dart';
import 'search/search_repository.dart';

class CatalogFacadeService {
  const CatalogFacadeService({
    @required this.homeRepository,
    @required this.companiesRepository,
    @required this.companyDetailsRepository,
    @required this.favoriteRepository,
    @required this.filterRepository,
    @required this.searchRepository,
    @required this.nearByRepository,
  });

  final HomeRepository homeRepository;
  final CompaniesRepository companiesRepository;
  final CompanyDetailsRepository companyDetailsRepository;
  final FavoriteRepository favoriteRepository;
  final FilterRepository filterRepository;
  final SearchRepository searchRepository;
  final NearByRepository nearByRepository;

  Future<ResponseWrapper<List<CategoryResponse>>> getCategories({
    @required int page,
    @required int size,
    @required bool mainPage,
  }) async {
    return homeRepository.getCategories(
      page: page,
      size: size,
      mainPage: mainPage,
    );
  }

  Future<ResponseWrapper<List<AdResponse>>> getAds() async {
    return homeRepository.getAds();
  }

  Future<ResponseWrapper<List<CategoryResponse>>> getCategorySubCategories({
    @required int page,
    @required int size,
    @required String parentId,
  }) async {
    return companiesRepository.getSubCategories(
      page: page,
      size: size,
      parentId: parentId,
    );
  }

  Future<ResponseWrapper<List<CompanyResponse>>> getCompanies({
    @required int page,
    @required int size,
    @required List<String> parentCategoriesIds,
  }) async {
    return companiesRepository.getCompanies(
      page: page,
      size: size,
      parentCategoriesIds: parentCategoriesIds,
    );
  }

  Future<ResponseWrapper<CompanyDetailsResponse>> getCompanyDetails({
    @required String id,
  }) async {
    return companyDetailsRepository.getCompanyDetails(
      id: id,
    );
  }

  Future<ResponseWrapper<List<CompanyResponse>>> getFavoriteCompanies({
    @required int page,
    @required int size,
    @required List<String> favoriteCompaniesIds,
  }) async {
    return favoriteRepository.getFavoriteCompanies(
      page: page,
      size: size,
      favoriteCompaniesIds: favoriteCompaniesIds,
    );
  }

  Future<ResponseWrapper<List<CategoryResponse>>> getFilterCategories({
    @required bool mainPage,
  }) async {
    return filterRepository.getCategories(
      mainPage: mainPage,
    );
  }

  Future<ResponseWrapper<List<CategoryResponse>>> getFilterSubCategories({
    @required String parentId,
  }) async {
    return filterRepository.getSubCategories(
      parentId: parentId,
    );
  }

  Future<ResponseWrapper<List<CityResponse>>> getFilterCities() async {
    return filterRepository.getCities();
  }

  Future<ResponseWrapper<List<CompanyResponse>>> getSearchCompanies({
    @required int page,
    @required int size,
    @required List<String> parentCategoriesIds,
    @required String cityId,
    @required String searchTerm,
  }) async {
    return searchRepository.getSearchCompanies(
      page: page,
      size: size,
      parentCategoriesIds: parentCategoriesIds,
      cityId: cityId,
      searchTerm: searchTerm,
    );
  }

  Future<ResponseWrapper<List<CompanyResponse>>> getNearByCompanies({
    @required double longitude,
    @required double latitude,
  }) async {
    return nearByRepository.getNearByCompanies(
      longitude: longitude,
      latitude: latitude,
    );
  }
}
