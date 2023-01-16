import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetFilterSubCategoriesRemoteDataProvider {
  GetFilterSubCategoriesRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getSubCategories({
    @required String parentId,
  }) async {
    final params = {
      'parentId': parentId,
    };
    Response response = await dio.get(Urls.GET_CATEGORY_SUB_CATEGORIES,
        queryParameters: params);
    return response;
  }
}
