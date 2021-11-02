import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launcher/src/blocs/opacity_cubit.dart';
import 'package:launcher/src/data/repositories/apps_repository.dart';
import 'package:launcher/src/routes/routes.dart';
import 'blocs/blocs.dart';

class MyApp extends StatelessWidget {
  MyApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OpacityCubit>(create: (_) => OpacityCubit()),
        BlocProvider<AppsCubit>(create: (_) => AppsCubit()),
        BlocProvider<ShortcutAppsCubit>(
            create: (_) => ShortcutAppsCubit(AppsCubit())),
      ],
      child: MaterialApp(
        showPerformanceOverlay: false,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.pink,
            accentColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            canvasColor: Colors.transparent),
        darkTheme: ThemeData(
          brightness: Brightness.light,
        ),
        title: "Ubuntu Launcher",
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
