class ContentItem {
  final String id;
  final String title;
  final String category;
  final String rating;
  final String year;
  final String poster;
  final String description;

  const ContentItem({
    required this.id,
    required this.title,
    required this.category,
    required this.rating,
    required this.year,
    required this.poster,
    required this.description,
  });

  factory ContentItem.fromMap(Map<String, dynamic> map) => ContentItem(
        id: '${map['id'] ?? ''}',
        title: '${map['title'] ?? ''}',
        category: '${map['category'] ?? ''}',
        rating: '${map['rating'] ?? 'N/A'}',
        year: '${map['year'] ?? ''}',
        poster: '${map['poster'] ?? ''}',
        description: '${map['description'] ?? ''}',
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'category': category,
        'rating': rating,
        'year': year,
        'poster': poster,
        'description': description,
      };
}
