import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:video_stream_clone/src/core/app_color.dart';
import 'package:video_stream_clone/src/core/app_const.dart';
import 'package:video_stream_clone/src/presentation/Home/movie_card.dart';
import 'package:video_stream_clone/src/presentation/Home/shows_slider.dart';
import 'package:video_stream_clone/src/presentation/Home/wide_movie_card.dart';

class HomePage extends StatelessWidget {
  final GraphQLClient dataClient;

  const HomePage({super.key, required this.dataClient});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shows Slider
          ShowsSlider(client: dataClient),
          SizedBox(height: 10.h),

          // Padding for sections
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Newest releases"),
                SizedBox(height: 10.h),
                _buildHorizontalMovieList(itemCount: 8, subscribeIndex: 4),
                SizedBox(height: 10.h),

                _buildSectionTitle("Wanzami Original"),
                SizedBox(height: 10.h),
                _buildHorizontalWideList(itemCount: 8, subscribeIndex: 1),
                SizedBox(height: 10.h),

                // _buildSectionTitleWithSeeAll("Latest Events"),
                // SizedBox(height: 10.h),
                // _buildHorizontalMovieList(itemCount: 8, subscribeIndex: 0),
                // SizedBox(height: 10.h),
                //
                // _buildSectionTitleWithSeeAll("Latest Shows"),
                // SizedBox(height: 10.h),
                // _buildHorizontalWideList(itemCount: 8, subscribeIndex: 1),
                // SizedBox(height: 10.h),
                //
                // _buildSectionTitleWithSeeAll("Best in Sports"),
                // SizedBox(height: 10.h),
                // _buildHorizontalWideList(itemCount: 8, subscribeIndex: 1),
                // SizedBox(height: 10.h),
                //
                // _buildSectionTitleWithSeeAll("Live TV & Radio"),
                // SizedBox(height: 10.h),
                // _buildHorizontalWideList(itemCount: 8, subscribeIndex: 1),
                // SizedBox(height: 10.h),
                //
                // _buildSectionTitleWithSeeAll("Popular Events"),
                // SizedBox(height: 10.h),
                // _buildHorizontalMovieList(itemCount: 8, subscribeIndex: 4),
                // SizedBox(height: 10.h),
                //
                // _buildSectionTitleWithSeeAll("Popular Shows"),
                // SizedBox(height: 10.h),
                // _buildHorizontalWideList(itemCount: 8, subscribeIndex: 1),
                // SizedBox(height: 50.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Section title without "See All"
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
        fontSize: 15,
      ),
    );
  }

  // Section title with "See All"
  Widget _buildSectionTitleWithSeeAll(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: fontFamily,
            fontSize: 15,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () {},
          child: ShaderMask(
            shaderCallback: (rect) =>
                AppColor.linearGradientPrimary.createShader(rect),
            child: const Text(
              "See All",
              style: TextStyle(
                color: Colors.white,
                fontFamily: fontFamily,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Horizontal list of MovieCards
  Widget _buildHorizontalMovieList(
      {required int itemCount, required int subscribeIndex}) {
    return SizedBox(
      height: 160.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) =>
            MovieCard(isSubscribe: index == subscribeIndex),
      ),
    );
  }

  // Horizontal list of WideWidgetCards
  Widget _buildHorizontalWideList(
      {required int itemCount, required int subscribeIndex}) {
    return SizedBox(
      height: 80.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) =>
            WideWidgetCard(isSubscribe: index == subscribeIndex),
      ),
    );
  }
}
