import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launcher/src/blocs/opacity_cubit.dart';
import 'package:launcher/src/routes/routes.dart';
import 'blocs/blocs.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AppsCubit>(
            create: (_) => AppsCubit(),
          ),
          BlocProvider<OpacityCubit>(create: (_) => OpacityCubit()),
          BlocProvider<ShortcutAppsCubit>(create: (_) => ShortcutAppsCubit()),
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
        ));
  }
}
