import 'package:bloc/bloc.dart';
import 'package:device_apps/device_apps.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:launcher/src/data/provirders/apps_api_provider.dart';
import 'package:launcher/src/utilities/enums.dart';
import 'package:logger/logger.dart';

part 'apps_state.dart';

class AppsCubit extends Cubit<AppsState> {
  AppsCubit() : super(AppsInitiateState()) {
    getApps();
  }

  final appsApiProvider = AppsApiProvider();

  void getApps() async {
    emit(AppsLoading());
    try {
      List<Application> apps = await appsApiProvider.fetchAppList();
      apps.sort(
          (a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));

      Future.delayed(Duration(seconds: 5), () {
        // deleayed code here
        emit(AppsLoaded(
            apps: apps,
            sortType: SortOptions.Alphabetically.toString().split('.').last));
      });
    } catch (errorMessage) {
      Logger().v(errorMessage);
      emit(AppsError(errorMessage));
    }
  }

  void updateApps() async {
    if (state is AppsLoaded) {
      String sortType = state.props[1];
      List<Application> apps = await appsApiProvider.fetchAppList();
      emit(AppsLoaded(apps: apps, sortType: sortType));
      sortApps(sortType);
    }
  }

  void sortApps(String sortType) {
    List<Application> apps = [];

    if (state is AppsLoaded) {
      apps = state.props[0];
    }

    emit(AppsLoading());

    if (sortType == SortOptions.Alphabetically.toString().split('.').last) {
      apps.sort(
          (a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
    } else if (sortType ==
        SortOptions.InstallationTime.toString().split('.').last) {
      apps.sort((b, a) => a.installTimeMillis.compareTo(b.installTimeMillis));
    } else if (sortType == SortOptions.UpdateTime.toString().split('.').last) {
      apps.sort((b, a) => a.updateTimeMillis.compareTo(b.updateTimeMillis));
    }

    emit(AppsLoaded(apps: apps, sortType: sortType));
  }
}
