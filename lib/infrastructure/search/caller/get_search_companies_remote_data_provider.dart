import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetSearchCompaniesRemoteDataProvider {
  GetSearchCompaniesRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getCompanies({
    @required int page,
    @required int size,
    @required List<String> parentCategoriesIds,
    @required String cityId,
    @required String searchTerm,
  }) async {
    final Map<String, dynamic> params = {
      'page': page,
      'size': size,
      'parentCategories': parentCategoriesIds,
      'cityId': cityId,
      'searchTerm': searchTerm,
    };
    Response response =
        await dio.get(Urls.GET_COMPANIES, queryParameters: params);
    return response;
  }
}
