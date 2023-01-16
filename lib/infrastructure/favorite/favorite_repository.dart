import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/app_const.dart';
import '../api/response_type.dart' as ResType;
import '../api/response_wrapper.dart';
import '../common_response/company_response.dart';
import 'caller/get_favorite_companies_remote_data_provider.dart';
import 'favorite_interface.dart';

class FavoriteRepository implements FavoriteInterface {
  FavoriteRepository({@required this.getFavoriteCompaniesRemoteDataProvider});

  final GetFavoriteCompaniesRemoteDataProvider
      getFavoriteCompaniesRemoteDataProvider;
  @override
  Future<ResponseWrapper<List<CompanyResponse>>> getFavoriteCompanies(
      {int page, int size, List<String> favoriteCompaniesIds}) async {
    try {
      Response response =
          await getFavoriteCompaniesRemoteDataProvider.getFavoriteCompanies(
        page: page,
        size: size,
        favoriteCompaniesIds: favoriteCompaniesIds,
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
      res.totalSize = remoteResponse.data[AppConst.DATA][AppConst.TOTAL_SIZE] as int;
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
