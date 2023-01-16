import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetCategorySubCategoriesRemoteDataProvider {
  GetCategorySubCategoriesRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getSubCategories({
    @required int page,
    @required int size,
    @required String parentId,
  }) async {
    final params = {
      'page': page ,
      'size': size ,
      'parentId': parentId ,
    };
    Response response = await dio.get(Urls.GET_CATEGORY_SUB_CATEGORIES, queryParameters: params);
    return response;
  }
}
