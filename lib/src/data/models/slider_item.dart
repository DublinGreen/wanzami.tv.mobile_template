class SliderItem {
  final String id;
  final String name;
  final String? description;
  final String? imageLink;
  final String? backgroundLink;

  SliderItem({
    required this.id,
    required this.name,
    this.description,
    this.imageLink,
    this.backgroundLink,
  });

  factory SliderItem.fromJson(Map<String, dynamic> json) {
    return SliderItem(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'],
      imageLink: json['image_link'],
      backgroundLink: json['background_link'],
    );
  }
}