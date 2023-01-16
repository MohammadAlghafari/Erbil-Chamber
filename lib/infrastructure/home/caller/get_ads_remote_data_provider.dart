import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetAdsRemoteDataProvider {
  GetAdsRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getAds() async {
    Response response = await dio.get(
      Urls.GET_ADS,
    );
    return response;
  }
}
