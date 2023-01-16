import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetFavoriteCompaniesRemoteDataProvider {
  GetFavoriteCompaniesRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getFavoriteCompanies({
    @required int page,
    @required int size,
    @required List<String> favoriteCompaniesIds,
  }) async {
    final Map<String, dynamic> params = {
      'page': page,
      'size': size,
      'ids': favoriteCompaniesIds
    };
    Response response =
        await dio.get(Urls.GET_COMPANIES, queryParameters: params);
    return response;
  }
}
