import 'package:flutter/material.dart';

import '../api/response_wrapper.dart';
import '../common_response/company_response.dart';

abstract class NearByInterface {
  Future<ResponseWrapper<List<CompanyResponse>>> getNearByCompanies({
    @required double longitude,
    @required double latitude,
  });
}
