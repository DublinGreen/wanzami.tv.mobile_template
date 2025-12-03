import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shimmer/shimmer.dart';

import 'package:video_stream_clone/src/core/app_color.dart';
import 'package:video_stream_clone/src/data/graphql/slider_query.dart';
import 'package:video_stream_clone/src/data/models/slider_item.dart';

import 'package:cached_network_image/cached_network_image.dart';

class ShowsSlider extends StatelessWidget {
  final GraphQLClient client;

  const ShowsSlider({super.key, required this.client});

  // Helper to encode URLs with spaces or special characters
  String? encodeUrl(String? url) {
    if (url == null) return null;
    return Uri.encodeFull(url);
  }

  // Helper to show GraphQL data in an AlertDialog
  void showDataDialog(BuildContext context, Map<String, dynamic> data) {
    final jsonString = const JsonEncoder.withIndent('  ').convert(data);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("GraphQL Data"),
          content: SingleChildScrollView(
            child: Text(jsonString),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

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
          variables: {
            'country': 'Nigeria',
          },
        ),
        builder: (result, {refetch, fetchMore}) {
          if (result.isLoading) {
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: double.infinity,
                    ),
                  ),
                );
              },
            );
          }

          if (result.hasException) {
            return Center(child: Text(result.exception.toString()));
          }

          // Show the fetched data in an alert dialog
          if (result.data != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // showDataDialog(context, result.data!);
            });
          }

          // Correct path for the API response
          final List rawList =
              (result.data?['findAllVideoByRestrictedCountry'] as List<dynamic>?) ?? [];

          final sliders = rawList
              .map((e) => SliderItem.fromJson(e))
              .where((item) => item.status == 1)
              .toList();

          if (sliders.isEmpty) {
            return const Center(child: Text("No active sliders"));
          }

          return CarouselSlider.builder(
            itemCount: sliders.length,
            options: CarouselOptions(
              enlargeCenterPage: true,
              height: 170.h,
              viewportFraction: 0.78,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 7),
            ),
            itemBuilder: (context, index, realIndex) {
              final item = sliders[index];

              return Stack(
                children: [
                  // Banner Image
                  Padding(
                    padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          // FadeInImage.assetNetwork(
                          //   placeholder: 'https://via.placeholder.com/300',
                          //   image: encodeUrl(item.banner) ?? '',
                          //   fit: BoxFit.cover,
                          //   width: double.infinity,
                          //   height: double.infinity,
                          //   fadeInDuration: const Duration(milliseconds: 500),
                          //   imageErrorBuilder: (_, __, ___) {
                          //     return Image.network(
                          //       'https://via.placeholder.com/300',
                          //       fit: BoxFit.cover,
                          //       width: double.infinity,
                          //       height: double.infinity,
                          //     );
                          //   },
                          // ),
                          CachedNetworkImage(
                            imageUrl: encodeUrl(item.banner) ?? '',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,

                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[800]!,
                              highlightColor: Colors.grey[600]!,
                              child: Container(color: Colors.grey[700]),
                            ),

                            errorWidget: (context, url, error) => Image.network(
                              'https://via.placeholder.com/300',
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Gradient overlay at the bottom
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 60.h,
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black54,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Subscribe Button Overlay
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

                  // Name + Short Description Overlay
                  Positioned(
                    left: 16.w,
                    bottom: 16.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            shadows: const [
                              Shadow(
                                blurRadius: 2,
                                color: Colors.black,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                        if (item.shortDescription != null) ...[
                          SizedBox(height: 2.h),
                          SizedBox(
                            width: 200.w,
                            child: Text(
                              item.shortDescription!,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.sp,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
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
