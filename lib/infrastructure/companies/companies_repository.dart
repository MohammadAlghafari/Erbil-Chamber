import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../common/app_const.dart';
import '../api/response_type.dart' as ResType;
import '../api/response_wrapper.dart';
import '../common_response/category_response.dart';
import '../common_response/company_response.dart';
import 'caller/get_category_sub_categories_remote_data_provider.dart';
import 'caller/get_companies_remote_data_provider.dart';
import 'companies_interface.dart';

class CompaniesRepository implements CompaniesInterface {
  CompaniesRepository(
      {@required this.getCategorySubCategoriesRemoteDataProvider,
      @required this.getCompaniesRemoteDataProvider});
  final GetCategorySubCategoriesRemoteDataProvider
      getCategorySubCategoriesRemoteDataProvider;
  final GetCompaniesRemoteDataProvider getCompaniesRemoteDataProvider;

  @override
  Future<ResponseWrapper<List<CategoryResponse>>> getSubCategories(
      {int page, int size, String parentId}) async {
    try {
      Response response =
          await getCategorySubCategoriesRemoteDataProvider.getSubCategories(
        page: page,
        size: size,
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

  @override
  Future<ResponseWrapper<List<CompanyResponse>>> getCompanies(
      {int page, int size, List<String> parentCategoriesIds}) async {
    try {
      Response response = await getCompaniesRemoteDataProvider.getCompanies(
        page: page,
        size: size,
        parentCategoriesIds: parentCategoriesIds,
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
