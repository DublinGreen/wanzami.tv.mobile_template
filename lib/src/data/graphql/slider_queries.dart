const String findAllSlidersQuery = r'''
query FindAllVideoByRestrictedCountry {
  findAllVideoByRestrictedCountry(country: "Nigeria") {
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