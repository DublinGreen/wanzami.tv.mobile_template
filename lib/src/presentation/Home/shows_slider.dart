import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shimmer/shimmer.dart';

import 'package:video_stream_clone/src/core/app_color.dart';
import 'package:video_stream_clone/src/data/graphql/slider_queries.dart';
import 'package:video_stream_clone/src/data/models/slider_item.dart';

class ShowsSlider extends StatelessWidget {
  final GraphQLClient client; // <-- Inject the client

  const ShowsSlider({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    const bgColor = Color.fromRGBO(20, 21, 26, 1);

    return Container(
      height: 180.h,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: bgColor),
      child: Query(
        options: QueryOptions(
          document: gql(findAllSlidersQuery),
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.isLoading) {
            // Shimmer placeholders while loading
            return CarouselSlider.builder(
              itemCount: 5,
              options: CarouselOptions(
                enlargeCenterPage: true,
                height: 170.h,
                viewportFraction: 0.78,
              ),
              itemBuilder: (context, index, realIndex) {
                return Padding(
                  padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[800]!,
                    highlightColor: Colors.grey[600]!,
                    child: Stack(
                      children: [
                        Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[700],
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 14.w,
                          top: 30.h,
                          child: Container(
                            height: 27.h,
                            width: 27.h,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16.w,
                          bottom: 20.h,
                          child: Container(
                            height: 16.h,
                            width: 120.w,
                            decoration: BoxDecoration(
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          if (result.hasException) {
            return Center(child: Text(result.exception.toString()));
          }

          final List slidersData =
              (result.data?['findAllSliders'] as List<dynamic>?) ?? [];

          final sliders =
              slidersData.map((e) => SliderItem.fromJson(e)).toList();

          if (sliders.isEmpty) {
            return const Center(child: Text("No sliders available"));
          }

          return CarouselSlider.builder(
            itemCount: sliders.length,
            options: CarouselOptions(
              enlargeCenterPage: true,
              height: 170.h,
              viewportFraction: 0.78,
              autoPlayInterval: const Duration(seconds: 7),
              autoPlay: true,
            ),
            itemBuilder: (BuildContext context, int index, int realIndex) {
              final item = sliders[index];
              final borderRadius =
                  BorderRadius.circular(realIndex == index ? 12 : 8);

              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                    child: Material(
                      elevation: 5,
                      borderRadius: borderRadius,
                      child: ClipRRect(
                        borderRadius: borderRadius,
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/placeholder.png',
                          image: item.imageLink ??
                              'https://via.placeholder.com/300',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          fadeInDuration: const Duration(milliseconds: 500),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 14.w,
                    top: 30.h,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: AppColor.linearGradientPrimary,
                        shape: BoxShape.circle,
                      ),
                      height: 27.h,
                      width: 27.h,
                      child: Transform.scale(
                        scale: 0.7,
                        child: Image.asset(
                          "assets/icons/ic_subscribe.png",
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16.w,
                    bottom: 20.h,
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
