const String findAllSlidersQuery = r'''
query FindAllVideoByRestrictedCountry($country: String!) {
  findAllVideoByRestrictedCountry(country: $country) {
      id
      status
      name
      description
      short_description
      thumbnail
      video_short_url
      banner
      reviews_rating
  }
}
''';