class SliderItem {
  final String id;
  final String name;
  final int status;
  final String? description;
  final String? shortDescription;
  final String? thumbnail;
  final String? videoShortUrl;
  final String? banner;
  final String? reviewsRating;

  SliderItem({
    required this.id,
    required this.name,
    required this.status,
    this.description,
    this.shortDescription,
    this.thumbnail,
    this.videoShortUrl,
    this.banner,
    this.reviewsRating,
  });

  factory SliderItem.fromJson(Map<String, dynamic> json) {
    return SliderItem(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      status: json['status'] is int
          ? json['status']
          : int.tryParse(json['status']?.toString() ?? '0') ?? 0,
      description: json['description'],
      shortDescription: json['short_description'],
      thumbnail: json['thumbnail'],
      videoShortUrl: json['video_short_url'],
      banner: json['banner'],
      reviewsRating: json['reviews_rating']?.toString(),
    );
  }
}