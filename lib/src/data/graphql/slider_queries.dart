import 'package:graphql_flutter/graphql_flutter.dart';

const String findAllSlidersQuery = r'''
query FindAllSliders {
  findAllSliders {
    id
    status
    name
    description
    duration
    video_quality
    image_link
    background_link
    video_link
  }
}
''';