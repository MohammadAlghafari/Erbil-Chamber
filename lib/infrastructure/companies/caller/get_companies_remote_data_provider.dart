import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetCompaniesRemoteDataProvider {
  GetCompaniesRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getCompanies({
    @required int page,
    @required int size,
    @required List<String> parentCategoriesIds,
  }) async {
    final Map<String, dynamic> params = {
      'page': page,
      'size': size,
      'parentCategories': parentCategoriesIds
    };
    Response response =
        await dio.get(Urls.GET_COMPANIES, queryParameters: params);
    return response;
  }
}
