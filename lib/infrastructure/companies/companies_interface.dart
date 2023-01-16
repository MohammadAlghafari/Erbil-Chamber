import 'package:flutter/material.dart';

import '../api/response_wrapper.dart';
import '../common_response/category_response.dart';
import '../common_response/company_response.dart';

abstract class CompaniesInterface {
  Future<ResponseWrapper<List<CategoryResponse>>> getSubCategories({
    @required int page,
    @required int size,
    @required String parentId,
  });

  Future<ResponseWrapper<List<CompanyResponse>>> getCompanies({
    @required int page,
    @required int size,
    @required List<String> parentCategoriesIds,
  });
}
