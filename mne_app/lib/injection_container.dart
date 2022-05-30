import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:mne_app/src/features/Entries/data/repositories/entries_repository_impl.dart';
import 'package:mne_app/src/features/Entries/domain/repositories/entries_repository.dart';
import 'package:mne_app/src/features/Profile/data/repositories/profile_repository_impl.dart';
import 'package:mne_app/src/features/Profile/domain/repositories/profile_repository.dart';
import 'package:mne_app/src/features/Reports/data/repositories/report_repositories_impl.dart';
import 'package:mne_app/src/features/Reports/domain/repositories/report_repository.dart';
import 'package:mne_app/src/features/Reports/presentation/bloc/reports_bloc.dart';
import 'src/features/AddEditEntry/data/repositories/entry_repository_impl.dart';
import 'src/features/AddEditEntry/domain/entry_repository.dart';
import 'src/features/AddEditEntry/presentation/bloc/entry_bloc.dart';
import 'src/features/Auth/data/repositories/auth_repository_impl.dart';
import 'src/features/Auth/domain/respositories/auth_repository.dart';
import 'src/features/Auth/presentation/bloc/auth_bloc.dart';
import 'src/features/Entries/presentation/bloc/entries_bloc.dart';
import 'src/features/Home/data/repositories/home_repository_impl.dart';
import 'src/features/Home/domain/repositories/home_repository.dart';
import 'src/features/Home/presentation/bloc/home_bloc.dart';
import 'src/features/Profile/presentation/bloc/profile_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/core/network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // Bloc
  sl.registerFactory(() => AuthBloc());

  // Repository
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(networkInfo: sl()));

  //! Features - Home
  // Bloc
  sl.registerFactory(() => HomeBloc());

  // Repository
  sl.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(networkInfo: sl()));

  //! Features - Entries
  // Bloc
  sl.registerFactory(() => EntriesBloc());

  // Repository
  sl.registerLazySingleton<EntriesRepository>(
      () => EntriesRepositoryImpl(networkInfo: sl()));

  //! Features - Entry
  // Bloc
  sl.registerFactory(() => EntryBloc());

  // Repository
  sl.registerLazySingleton<EntryRepository>(
      () => EntryRepositoryImpl(networkInfo: sl()));

  //! Features - Reports
  // Bloc
  sl.registerFactory(() => ReportsBloc());

  // Repository
  sl.registerLazySingleton<ReportsRepository>(
      () => ReportsRepositoryImpl(networkInfo: sl()));

  //! Features - Profile
  // Bloc
  sl.registerFactory(() => ProfileBloc());

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(networkInfo: sl()));

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfo(connectivity: sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Connectivity());
}
