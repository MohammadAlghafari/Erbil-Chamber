import 'package:erbilchamberapp/infrastructure/api/response_wrapper.dart';
import 'package:erbilchamberapp/infrastructure/common_response/company_response.dart';
import 'package:flutter/material.dart';

abstract class SearchInterface {
  Future<ResponseWrapper<List<CompanyResponse>>> getSearchCompanies({
    @required int page,
    @required int size,
    @required List<String> parentCategoriesIds,
    @required String cityId,
    @required String searchTerm,
  });
}
