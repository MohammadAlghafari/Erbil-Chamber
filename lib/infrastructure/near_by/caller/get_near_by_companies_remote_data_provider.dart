import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetNearByCompaniesRemoteDataProvider {
  GetNearByCompaniesRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getNearByCompanies({
    @required double longitude,
    @required double latitude,
  }) async {
    final Map<String, dynamic> params = {
      'page': 1,
      'size': 20,
      'longitude': longitude,
      'latitude': latitude,
    };
    Response response =
        await dio.get(Urls.GET_COMPANIES, queryParameters: params);
    return response;
  }
}
