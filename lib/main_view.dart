import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_stream_clone/src/bloc/bottom_nav_bar_cubit.dart';
import 'package:video_stream_clone/src/components/custom_bottom_nav_bar.dart';
import 'package:video_stream_clone/src/components/custom_drawer.dart';
import 'package:video_stream_clone/src/core/app_color.dart';
import 'package:video_stream_clone/src/core/app_const.dart';
import 'package:video_stream_clone/src/presentation/About/about_page.dart';
import 'package:video_stream_clone/src/presentation/Home/home_page.dart';
import 'package:video_stream_clone/src/presentation/LiveTv%20&%20Radio/liveTv_and_radio.dart';
import 'package:video_stream_clone/src/presentation/Movies/movies_page.dart';
import 'package:video_stream_clone/src/presentation/account/account_page.dart';
import 'package:video_stream_clone/src/presentation/dashboard/dashboard_page.dart';
import 'package:video_stream_clone/src/presentation/my_watch%20_ist/my_watch_list_page.dart';
import 'package:video_stream_clone/src/presentation/privacy_policy/privacy_policy.dart';
import 'package:video_stream_clone/src/presentation/settings/settings_page.dart';
import 'package:video_stream_clone/src/presentation/sports/sports_page.dart';
import 'package:video_stream_clone/src/presentation/tv_shows/tv_shows.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class MainPage extends StatefulWidget {
  final GraphQLClient dataClient;

  const MainPage({super.key, required this.dataClient});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isSearch = false;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    // Initialize pages here because widget is available
    pages = [
      HomePage(dataClient: widget.dataClient), // Pass the GraphQL client
      const MyWatchList(),
      const AccountPage(),
      const SettingsPage(),
      const TvShowsPage(),
      const TvEventsPage(),
      const SportsPage(),
      const LiveTvAndRadioPage(),
      const DashBoardPage(),
      const PrivacyPolicy(),
      const AboutPage(),
      const Placeholder(), // Podcast Page (Soon . . .)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarCubit, int>(
      builder: (context, indexState) {
        return Scaffold(
          bottomNavigationBar: CustomBottomNavBar(indexState: indexState),
          drawer: SafeArea(child: CustomDrawer(dataClient: widget.dataClient)),
          backgroundColor: AppColor.backgroundColor,
          appBar: isSearch
              ? AppBar(
                  leading: IconButton(
                    onPressed: () => setState(() => isSearch = false),
                    icon: const FaIcon(
                      FontAwesomeIcons.arrowLeft,
                      color: Colors.white,
                      size: 19,
                    ),
                  ),
                  flexibleSpace: const DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: AppColor.linearGradientPrimary),
                  ),
                  title: TextField(
                    cursorColor: AppColor.pinkColor,
                    keyboardType: TextInputType.name,
                    style: const TextStyle(
                      color:AppColor.pinkColor,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.w400,
                      fontSize: 19,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                          color: AppColor.pinkColor.withOpacity(0.5),
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w100,
                          fontSize: 19),
                      // filled: true, // <-- Enable background color
                      // fillColor: Colors.orange, // <-- Set the background color here
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                )
              : AppBar(
                  leading: Builder(
                    builder: (context) => IconButton(
                      icon: Image.asset(
                        "assets/icons/ic_side_nav.png",
                        height: 35,
                        width: 35,
                      ),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
            backgroundColor: AppColor.pinkColor, // <-- Set the background color here for the Top App Bar
            title: Transform.translate(
                    offset: Offset(0, -3.h),
                    child: Text(
                      _getAppBarTitle(indexState),
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: fontFamily,
                          fontSize: 20.3),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Image.asset(
                        "assets/icons/ic_search.png",
                        height: 35,
                        width: 35,
                      ),
                      onPressed: () => setState(() => isSearch = true),
                    ),
                    SizedBox(width: 5.w),
                  ],
                  flexibleSpace: const DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: AppColor.linearGradientPrimary),
                  ),
                ),
          body: pages[indexState],
        );
      },
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return "Home";
      case 1:
        return "Watchlist";
      case 2:
        return "Account";
      case 3:
        return "Settings";
      case 4:
        return "TV Shows";
      case 5:
        return "Events";
      case 6:
        return "Sports";
      case 7:
        return "Live TV & Radio";
      case 8:
        return "Dashboard";
      case 9:
        return "Privacy Policy";
      case 10:
        return "About";
      default:
        return "Podcast";
    }
  }
}
