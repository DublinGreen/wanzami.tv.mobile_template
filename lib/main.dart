import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_stream_clone/src/bloc/bottom_nav_bar_cubit.dart';
import 'package:video_stream_clone/src/bloc/drawer_cubit.dart';
import 'package:video_stream_clone/src/core/app_extension.dart';
import 'package:video_stream_clone/main_view.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:video_stream_clone/src/core/app_const.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter(); // REQUIRED
  runApp(const MainApp());
}

final httpLink1 = HttpLink(authAPI);
final httpLink2 = HttpLink(dataAPI);

final clientOne = ValueNotifier(
  GraphQLClient(
    link: httpLink1,
    cache: GraphQLCache(store: InMemoryStore()),
  ),
);

final clientTwo = ValueNotifier(
  GraphQLClient(
    link: httpLink2,
    cache: GraphQLCache(store: InMemoryStore()),
  ),
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = ThemeData(useMaterial3: true);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ));

    return GraphQLProvider(
      client: clientOne, // default auth client
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => DrawerCubit()),
          BlocProvider(create: (_) => BottomNavBarCubit()),
        ],
        child: ScreenUtilInit(
          designSize: Size(context.width, context.height),
          builder: (context, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: themeData,
              home: MainPage(dataClient: clientTwo.value), // pass clientTwo
            );
          },
        ),
      ),
    );
  }
}
