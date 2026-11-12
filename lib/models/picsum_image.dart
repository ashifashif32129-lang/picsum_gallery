
class PicsumImage {
  final int id;
  final String title;
  final String thumbnail;
  final List<String> images;

  PicsumImage({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.images,
  });

  factory PicsumImage.fromJson(Map<String, dynamic> json) {
    return PicsumImage(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled',
      thumbnail: json['thumbnail'] ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }
}
