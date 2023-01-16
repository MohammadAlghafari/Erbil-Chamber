import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../api/urls.dart';

class GetFilterCitesRemoteDataProvider {
  GetFilterCitesRemoteDataProvider({@required this.dio});

  final Dio dio;

  Future<dynamic> getCities() async {
    Response response = await dio.get(
      Urls.GET_CITIES,
    );
    return response;
  }
}
