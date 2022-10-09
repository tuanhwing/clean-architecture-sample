import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:th_core/th_core.dart';

import '../core/data/data.dart';
import '../core/domain/domain.dart';
import '../core/presentation/presentation.dart';

///Injector
class GoterInjector {
  ///inject function
  Future<void> inject() async {
    PackageInfo package = await PackageInfo.fromPlatform();
    //Common
    GetIt.I.registerLazySingleton<DeviceInfoPlugin>(() => DeviceInfoPlugin());
    GetIt.I.registerLazySingleton<PackageInfo>(() => package);
    GetIt.I.registerLazySingleton<DeviceInfoDataSource>(
        () => DeviceInfoDataSourceImpl(
              GetIt.I.get<DeviceInfoPlugin>(),
              GetIt.I.get<PackageInfo>(),
            ));

    //Blocs
    GetIt.I.registerLazySingleton<AppBloc>(() => AppBloc());

    //Data
    GetIt.I.registerLazySingleton<UserLocalDataSource>(
        () => UserLocalDataSourceImpl(GetIt.I.get()));
    GetIt.I.registerLazySingleton<UserRemoteDataSource>(
        () => UserRemoteDataSourceImpl(
              GetIt.I.get(),
              GetIt.I.get(),
            ));

    //Repository
    GetIt.I.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
        localDataSource: GetIt.I.get<UserLocalDataSource>(),
        remoteDataSource: GetIt.I.get<UserRemoteDataSource>()));

    //Use case
    GetIt.I.registerLazySingleton<FetchProfileUseCase>(
        () => FetchProfileUseCase(GetIt.I.get()));
    GetIt.I.registerLazySingleton<GetCachedProfileUseCase>(
        () => GetCachedProfileUseCase(GetIt.I.get()));
    GetIt.I.registerLazySingleton<LogoutUseCase>(
        () => LogoutUseCase(GetIt.I.get()));
    return;
  }
}
