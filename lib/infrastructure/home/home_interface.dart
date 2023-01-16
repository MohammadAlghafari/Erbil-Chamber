import 'package:flutter/material.dart';

import '../api/response_wrapper.dart';
import '../common_response/category_response.dart';
import 'response/ad_response.dart';

abstract class HomeInterface {
  Future<ResponseWrapper<List<CategoryResponse>>> getCategories({
    @required int page,
    @required int size,
    @required bool mainPage,
  });

  Future<ResponseWrapper<List<AdResponse>>> getAds();
}
