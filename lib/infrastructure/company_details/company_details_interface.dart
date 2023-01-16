import 'package:flutter/material.dart';

import '../api/response_wrapper.dart';
import 'response/company_details_response.dart';

abstract class CompanyDetailsInterface {
  Future<ResponseWrapper<CompanyDetailsResponse>> getCompanyDetails({
    @required String id,
  });
}
