import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_news_app/config/constant_config.dart';
import 'package:flutter_news_app/config/flavor_config.dart';
import 'package:flutter_news_app/core/network/network_info.dart';
import 'package:flutter_news_app/core/util/dio_logging_interceptor.dart';
import 'package:flutter_news_app/feature/data/datasource/news/news_remote_data_source.dart';
import 'package:flutter_news_app/feature/data/repository/news/news_repository_impl.dart';
import 'package:flutter_news_app/feature/domain/repository/news/news_repository.dart';
import 'package:flutter_news_app/feature/domain/usecase/gettopheadlinesnews/get_top_headlines_news.dart';
import 'package:flutter_news_app/feature/domain/usecase/searchtopheadlinesnews/search_top_headlines_news.dart';
import 'package:flutter_news_app/feature/presentation/bloc/topheadlinesnews/bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  /**
   * ! Features
   */
  // Bloc
  sl.registerFactory(
    () => TopHeadlinesNewsBloc(
      getTopHeadlinesNews: sl(),
      searchTopHeadlinesNews: sl(),
    ),
  );

  // Use Case
  sl.registerLazySingleton(() => GetTopHeadlinesNews(newsRepository: sl()));
  sl.registerLazySingleton(() => SearchTopHeadlinesNews(newsRepository: sl()));

  // Repository
  sl.registerLazySingleton<NewsRepository>(() => NewsRepositoryImpl(newsRemoteDataSource: sl(), networkInfo: sl()));

  // Data Source
  sl.registerLazySingleton<NewsRemoteDataSource>(() => NewsRemoteDataSourceImpl(dio: sl(), constantConfig: sl()));

  /**
   * ! Core
   */
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  /**
   * ! External
   */
  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.options.baseUrl = FlavorConfig.instance.values.baseUrl;
    dio.interceptors.add(DioLoggingInterceptor());
    return dio;
  });
  sl.registerLazySingleton(() => ConstantConfig());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
