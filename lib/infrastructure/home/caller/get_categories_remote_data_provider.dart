import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetCategoriesRemoteDataProvider {
  GetCategoriesRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getCategories({
    @required int page,
    @required int size,
    @required bool mainPage,
  }) async {
    final params = {
      'page': page ,
      'size': size ,
      'mainPage': mainPage ,
    };
    Response response = await dio.get(Urls.GET_CATEGORIES, queryParameters: params);
    return response;
  }
}
