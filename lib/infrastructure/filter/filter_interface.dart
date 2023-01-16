import 'package:flutter/material.dart';

import '../api/response_wrapper.dart';
import '../common_response/category_response.dart';
import '../common_response/city_response.dart';

abstract class FilterInterface {
  Future<ResponseWrapper<List<CategoryResponse>>> getCategories({
    @required bool mainPage,
  });

  Future<ResponseWrapper<List<CategoryResponse>>> getSubCategories({
    @required String parentId,
  });

  Future<ResponseWrapper<List<CityResponse>>> getCities();
}
