import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetCompanyDetailsRemoteDataProvider {
  GetCompanyDetailsRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getCompanyDetails({
    @required String id,
  }) async {
   
    Response response = await dio.get(Urls.GET_COMPANY_DETAILS+'/$id',);
    return response;
  }
}
