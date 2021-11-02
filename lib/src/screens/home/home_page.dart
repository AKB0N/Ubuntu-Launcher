import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launcher/src/blocs/apps_cubit.dart';
import 'package:launcher/src/blocs/opacity_cubit.dart';
import 'package:launcher/src/blocs/shortcut_apps_cubit.dart';
import 'package:launcher/src/screens/app_drawer/app_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatelessWidget {
  static const route = '/';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Application> apps;
  String settingsPackageName;
  String cameraPackageName;
  String messagesPackageName;
  double sidebarOpacity = 1;
  bool autoOpenDrawer;
  bool isDrawerEnable = false;

  _launchCaller() async {
    const url = "tel:";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final appsCubit = BlocProvider.of<AppsCubit>(context);

    final opacityCubit = BlocProvider.of<OpacityCubit>(context);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Color.fromRGBO(39, 21, 40, 0.5),
      ),
    );
    return WillPopScope(
      onWillPop: () async => false,
      child: Focus(
        onFocusChange: (isFocusChanged) {
          if (isFocusChanged) {
            opacityCubit.opacityReset();
            appsCubit.updateApps();
          }
        },
        child: Scaffold(
          endDrawerEnableOpenDragGesture: isDrawerEnable,
          drawer: BlocBuilder<ShortcutAppsCubit, ShortcutAppsState>(
            builder: (context, shortcutAppsState) {
              if (shortcutAppsState is ShortcutAppsLoaded) {
                isDrawerEnable = true;
                return BlocBuilder<OpacityCubit, OpacityState>(
                  builder: (context, state) {
                    return Opacity(
                      opacity: state is OpacityInitial ? 1 : .30,
                      child: SafeArea(
                        child: Container(
                          color: Color.fromRGBO(39, 21, 40, 0.5),
                          height: MediaQuery.of(context).size.height,
                          width: 60.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      opacityCubit.setOpacitySemi();

                                      Navigator.pushNamed(
                                          context, AppDrawer.route);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: ClipRRect(
                                        child: Hero(
                                          tag: 'drawer',
                                          child: Image.asset(
                                            "assets/images/drawer.png",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(children: [
                                shortcutAppsBuild(
                                  Icon(
                                    Icons.phone,
                                    color: Colors.white,
                                  ),
                                  () => _launchCaller(),
                                ),
                                shortcutAppsBuild(
                                  Icon(
                                    Icons.sms,
                                    color: Colors.white,
                                  ),
                                  () => DeviceApps.openApp(shortcutAppsState
                                      .shortcutApps[1].packageName),
                                ),
                                shortcutAppsBuild(
                                  Icon(
                                    Icons.camera,
                                    color: Colors.white,
                                  ),
                                  () => DeviceApps.openApp(shortcutAppsState
                                      .shortcutApps[2].packageName),
                                ),
                                shortcutAppsBuild(
                                  Icon(
                                    Icons.settings,
                                    color: Colors.white,
                                  ),
                                  () => DeviceApps.openApp(shortcutAppsState
                                      .shortcutApps[3].packageName),
                                )
                              ]),
                              Opacity(
                                opacity: 0,
                                child: IconButton(
                                    onPressed: () {}, icon: Icon(Icons.menu)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else
                return Container();
            },
          ),
          body: BlocBuilder<AppsCubit, AppsState>(builder: (context, state) {
            if (state is AppsLoading)
              return SafeArea(
                child: Container(
                  key: scaffoldKey,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/boot2.gif"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              );
            else if (state is AppsLoaded) {
              apps = state.apps;
              // getShortcutApps(apps);
              return Container(
                key: scaffoldKey,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/wallpaper.jpg"),
                  fit: BoxFit.cover,
                )),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        scaffoldKey.currentState.openDrawer();
                      },
                      child: Container(
                          color: Colors.transparent,
                          height: MediaQuery.of(context).size.height,
                          child: SizedBox(
                            width: 70,
                          )),
                    ),
                  ],
                ),
              );
            } else {
              return Stack(
                children: [
                  Container(
                    key: scaffoldKey,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image:
                          AssetImage("assets/images/ubuntu-splash-screen.gif"),
                      fit: BoxFit.fill,
                    )),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      "Something went wrong!",
                      style: TextStyle(color: Colors.red, fontSize: 24.0),
                    ),
                  )
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}

Widget shortcutAppsBuild(Icon icon, Function fn) {
  return Padding(
    padding: const EdgeInsets.only(top: 15.0),
    child: IconButton(icon: icon, onPressed: fn),
  );
}
