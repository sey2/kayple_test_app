import 'package:kayple_test/domain/post/entity/post_entity.dart';

final class PostResDto {
  PostResDto({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
    required this.isFavorite,
  });

  final int userId;
  final int id;
  final String? title;
  final String? body;
  final bool isFavorite;

  factory PostResDto.fromJson(Map<String, dynamic> json) {
    return PostResDto(
      userId: json["userId"],
      id: json["id"],
      title: json["title"],
      body: json["body"],
      isFavorite: false,
    );
  }

  PostEntity toEntity() {
    return PostEntity(
      id: id,
      title: title ?? '',
      body: body ?? '',
      isFavorite: isFavorite,
      userId: userId,
    );
  }
}
