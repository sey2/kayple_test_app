final class PostEntity {
  PostEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    this.isFavorite = false,
  });

  final int id;
  final String title;
  final String body;
  final int userId;
  final bool isFavorite;

  PostEntity copyWith({
    int? id,
    String? title,
    String? body,
    bool? isFavorite,
    int? userId,
  }) {
    return PostEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      userId: userId ?? this.userId,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
