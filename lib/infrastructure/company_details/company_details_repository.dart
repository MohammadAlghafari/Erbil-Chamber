import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/app_const.dart';
import '../api/response_type.dart' as ResType;
import '../api/response_wrapper.dart';
import 'caller/get_company_details_remote_data_provider.dart';
import 'company_details_interface.dart';
import 'response/company_details_response.dart';

class CompanyDetailsRepository implements CompanyDetailsInterface {
  CompanyDetailsRepository(
      {@required this.getCompanyDetailsRemoteDataProvider});
  final GetCompanyDetailsRemoteDataProvider getCompanyDetailsRemoteDataProvider;
  @override
  Future<ResponseWrapper<CompanyDetailsResponse>> getCompanyDetails(
      {String id}) async {
    try {
      Response response =
          await getCompanyDetailsRemoteDataProvider.getCompanyDetails(
        id: id,
      );
      return _prepareCompanyDetailsResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareCompanyDetailsResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareCompanyDetailsResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<CompanyDetailsResponse> _prepareCompanyDetailsResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<CompanyDetailsResponse>();
    if (remoteResponse != null) {
      res.data =
          CompanyDetailsResponse.fromMap(remoteResponse.data[AppConst.DATA]);

      res.hasError = remoteResponse.data[AppConst.HAS_ERROR] as bool;
      res.message = remoteResponse.data[AppConst.MESSAGE] as String;
      res.statusCode = remoteResponse.data[AppConst.STATUS_CODE] as int;
      res.totalSize = 1;
      switch (remoteResponse.statusCode) {
        case 200:
          res.responseType = ResType.ResponseType.SUCCESS;
          break;
        case 400:
        case 401:
          res.responseType = ResType.ResponseType.VALIDATION_ERROR;
          break;
        case 500:
          res.responseType = ResType.ResponseType.SERVER_ERROR;
          break;
      }
    } else {
      res.responseType = ResType.ResponseType.CLIENT_ERROR;
    }
    return res;
  }
}
