import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetFilterCategoriesRemoteDataProvider {
  GetFilterCategoriesRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getCategories({
    @required bool mainPage,
  }) async {
    final params = {
      'mainPage': mainPage ,
    };
    Response response = await dio.get(Urls.GET_CATEGORIES, queryParameters: params);
    return response;
  }
}
