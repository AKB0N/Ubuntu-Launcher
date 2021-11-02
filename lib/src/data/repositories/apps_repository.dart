import 'package:device_apps/device_apps.dart';
import 'package:logger/logger.dart';

class AppsRepository {
  Future<List<Application>> fetchAppList() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: true,
        onlyAppsWithLaunchIntent: true);

    return apps;
  }
}
