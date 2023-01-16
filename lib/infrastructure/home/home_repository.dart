import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/app_const.dart';
import '../api/response_type.dart' as ResType;
import '../api/response_wrapper.dart';
import '../common_response/category_response.dart';
import 'caller/get_ads_remote_data_provider.dart';
import 'caller/get_categories_remote_data_provider.dart';
import 'home_interface.dart';
import 'response/ad_response.dart';

class HomeRepository implements HomeInterface {
  HomeRepository(
      {@required this.getCategoriesRemoteDataProvider,
      @required this.getAdsRemoteDataProvider});

  final GetCategoriesRemoteDataProvider getCategoriesRemoteDataProvider;
  final GetAdsRemoteDataProvider getAdsRemoteDataProvider;

  @override
  Future<ResponseWrapper<List<CategoryResponse>>> getCategories(
      {int page, int size, bool mainPage}) async {
    try {
      Response response = await getCategoriesRemoteDataProvider.getCategories(
        page: page,
        size: size,
        mainPage: mainPage,
      );
      return _prepareCategoriesResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareCategoriesResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareCategoriesResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<List<CategoryResponse>> _prepareCategoriesResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<CategoryResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data[AppConst.DATA][AppConst.ITEMS] as List)
          .map((x) => CategoryResponse.fromMap(x))
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

  @override
  Future<ResponseWrapper<List<AdResponse>>> getAds() async {
    try {
      Response response = await getAdsRemoteDataProvider.getAds();
      return _prepareAdsResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareAdsResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareAdsResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<List<AdResponse>> _prepareAdsResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<AdResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data[AppConst.DATA][AppConst.ITEMS] as List)
          .map((x) => AdResponse.fromMap(x))
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
