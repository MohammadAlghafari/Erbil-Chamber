import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/app_const.dart';
import '../api/response_type.dart' as ResType;
import '../api/response_wrapper.dart';
import '../common_response/company_response.dart';
import 'caller/get_search_companies_remote_data_provider.dart';
import 'search_interface.dart';

class SearchRepository implements SearchInterface {
  SearchRepository({@required this.getSearchCompaniesRemoteDataProvider});
  final GetSearchCompaniesRemoteDataProvider
      getSearchCompaniesRemoteDataProvider;
  @override
  Future<ResponseWrapper<List<CompanyResponse>>> getSearchCompanies(
      {int page,
      int size,
      List<String> parentCategoriesIds,
      String cityId,
      String searchTerm}) async {
    try {
      Response response =
          await getSearchCompaniesRemoteDataProvider.getCompanies(
        page: page,
        size: size,
        parentCategoriesIds: parentCategoriesIds,
        cityId: cityId,
        searchTerm: searchTerm,
      );
      return _prepareCompaniesResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareCompaniesResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareCompaniesResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<List<CompanyResponse>> _prepareCompaniesResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<CompanyResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data[AppConst.DATA][AppConst.ITEMS] as List)
          .map((x) => CompanyResponse.fromMap(x))
          .toList();
      res.hasError = remoteResponse.data[AppConst.HAS_ERROR] as bool;
      res.message = remoteResponse.data[AppConst.MESSAGE] as String;
      res.statusCode = remoteResponse.data[AppConst.STATUS_CODE] as int;
      res.totalSize =
          remoteResponse.data[AppConst.DATA][AppConst.TOTAL_SIZE] as int;
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
