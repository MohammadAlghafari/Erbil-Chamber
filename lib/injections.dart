import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'application/companies/companies_bloc.dart';
import 'application/company_details/company_details_bloc.dart';
import 'application/favorite/favorite_bloc.dart';
import 'application/filter/filter_bloc.dart';
import 'application/home/home_bloc.dart';
import 'application/main/main_bloc.dart';
import 'application/near_by/near_by_bloc.dart';
import 'application/search/search_bloc.dart';
import 'common/pref_keys.dart';
import 'infrastructure/api/urls.dart';
import 'infrastructure/catalog_facade_service.dart';
import 'infrastructure/companies/caller/get_category_sub_categories_remote_data_provider.dart';
import 'infrastructure/companies/caller/get_companies_remote_data_provider.dart';
import 'infrastructure/companies/companies_repository.dart';
import 'infrastructure/company_details/caller/get_company_details_remote_data_provider.dart';
import 'infrastructure/company_details/company_details_repository.dart';
import 'infrastructure/favorite/caller/get_favorite_companies_remote_data_provider.dart';
import 'infrastructure/favorite/favorite_repository.dart';
import 'infrastructure/filter/caller/get_cities_remote_data_provider.dart';
import 'infrastructure/filter/caller/get_filter_categories_remote_data_provider.dart';
import 'infrastructure/filter/caller/get_filter_sub_categories_remote_data_provider.dart';
import 'infrastructure/filter/filter_repository.dart';
import 'infrastructure/home/caller/get_ads_remote_data_provider.dart';
import 'infrastructure/home/caller/get_categories_remote_data_provider.dart';
import 'infrastructure/home/home_repository.dart';
import 'infrastructure/near_by/caller/get_near_by_companies_remote_data_provider.dart';
import 'infrastructure/near_by/near_by_repository.dart';
import 'infrastructure/search/caller/get_search_companies_remote_data_provider.dart';
import 'infrastructure/search/search_repository.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async => appDependencies();

Future<void> appDependencies() async {
  serviceLocator.registerLazySingleton(() => CatalogFacadeService(
        homeRepository: serviceLocator(),
        companiesRepository: serviceLocator(),
        companyDetailsRepository: serviceLocator(),
        favoriteRepository: serviceLocator(),
        filterRepository: serviceLocator(),
        searchRepository: serviceLocator(),
        nearByRepository: serviceLocator(),
      ));

  serviceLocator.registerFactory(
    () => MainBloc(
      catalogService: serviceLocator(),
    ),
  );

  //! Home
  serviceLocator.registerFactory(
    () => HomeBloc(
      catalogService: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => HomeRepository(
      getCategoriesRemoteDataProvider: serviceLocator(),
      getAdsRemoteDataProvider: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => GetCategoriesRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => GetAdsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  //! Companies
  serviceLocator.registerFactory(
    () => CompaniesBloc(
      catalogService: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => CompaniesRepository(
      getCategorySubCategoriesRemoteDataProvider: serviceLocator(),
      getCompaniesRemoteDataProvider: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => GetCategorySubCategoriesRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => GetCompaniesRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  //! CompanyDetails
  serviceLocator.registerFactory(
    () => CompanyDetailsBloc(
      catalogService: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => CompanyDetailsRepository(
      getCompanyDetailsRemoteDataProvider: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => GetCompanyDetailsRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  //! Favorite
  serviceLocator.registerFactory(
    () => FavoriteBloc(
      catalogService: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => FavoriteRepository(
      getFavoriteCompaniesRemoteDataProvider: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => GetFavoriteCompaniesRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  //! Filter
  serviceLocator.registerFactory(
    () => FilterBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => FilterRepository(
      getFilterCategoriesRemoteDataProvider: serviceLocator(),
      getFilterSubCategoriesRemoteDataProvider: serviceLocator(),
      getFilterCitesRemoteDataProvider: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => GetFilterCategoriesRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetFilterSubCategoriesRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => GetFilterCitesRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  //! Search
  serviceLocator.registerFactory(
    () => SearchBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => SearchRepository(
      getSearchCompaniesRemoteDataProvider: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => GetSearchCompaniesRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  //! NearBy
  serviceLocator.registerFactory(
    () => NearByBloc(
      catalogService: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => NearByRepository(
      getNearByCompaniesRemoteDataProvider: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => GetNearByCompaniesRemoteDataProvider(
      dio: serviceLocator(),
    ),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(
    () => sharedPreferences,
  );
  serviceLocator.registerLazySingleton(
    () => getNetworkObj(),
  );
}

Dio getNetworkObj() {
  BaseOptions options = BaseOptions(
    baseUrl: Urls.BASE_URL,
    connectTimeout: 30000,
    receiveTimeout: 30000,
  );
  Dio dio = Dio(options);

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (RequestOptions options) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String lang = prefs.get(PrefsKeys.CULTURE_CODE);
        if (lang == null) {
          options.headers["Accept-Language"] = "en";
        } else {
          options.headers["Accept-Language"] = lang == 'fa' ? 'ku' : lang;
        }
        return options;
      },
    ),
  );
  dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90));
  return dio;
}
