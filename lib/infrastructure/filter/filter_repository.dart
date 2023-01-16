import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/app_const.dart';
import '../api/response_type.dart' as ResType;
import '../api/response_wrapper.dart';
import '../common_response/category_response.dart';
import '../common_response/city_response.dart';
import 'caller/get_cities_remote_data_provider.dart';
import 'caller/get_filter_categories_remote_data_provider.dart';
import 'caller/get_filter_sub_categories_remote_data_provider.dart';
import 'filter_interface.dart';

class FilterRepository implements FilterInterface {
  FilterRepository({
    @required this.getFilterCategoriesRemoteDataProvider,
    @required this.getFilterSubCategoriesRemoteDataProvider,
    @required this.getFilterCitesRemoteDataProvider,
  });

  final GetFilterCategoriesRemoteDataProvider
      getFilterCategoriesRemoteDataProvider;
  final GetFilterSubCategoriesRemoteDataProvider
      getFilterSubCategoriesRemoteDataProvider;
  final GetFilterCitesRemoteDataProvider getFilterCitesRemoteDataProvider;
  @override
  Future<ResponseWrapper<List<CategoryResponse>>> getCategories(
      {bool mainPage}) async {
    try {
      Response response =
          await getFilterCategoriesRemoteDataProvider.getCategories(
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
  Future<ResponseWrapper<List<CategoryResponse>>> getSubCategories(
      {String parentId}) async {
    try {
      Response response =
          await getFilterSubCategoriesRemoteDataProvider.getSubCategories(
        parentId: parentId,
      );
      return _prepareSubCategoriesResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareSubCategoriesResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareSubCategoriesResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<List<CategoryResponse>> _prepareSubCategoriesResponse(
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
  Future<ResponseWrapper<List<CityResponse>>> getCities() async {
    try {
      Response response = await getFilterCitesRemoteDataProvider.getCities();
      return _prepareCitiesResponse(
        remoteResponse: response,
      );
    } on DioError catch (e) {
      return _prepareCitiesResponse(
        remoteResponse: e.response,
      );
    } catch (e) {
      return _prepareCitiesResponse(
        remoteResponse: null,
      );
    }
  }

  ResponseWrapper<List<CityResponse>> _prepareCitiesResponse(
      {@required Response<dynamic> remoteResponse}) {
    var res = ResponseWrapper<List<CityResponse>>();
    if (remoteResponse != null) {
      res.data = (remoteResponse.data[AppConst.DATA][AppConst.ITEMS] as List)
          .map((x) => CityResponse.fromMap(x))
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
