import 'package:flutter/material.dart';

import '../api/response_wrapper.dart';
import '../common_response/company_response.dart';

abstract class FavoriteInterface{

   Future<ResponseWrapper<List<CompanyResponse>>> getFavoriteCompanies({
    @required int page,
    @required int size,
    @required List<String> favoriteCompaniesIds,
  });
}