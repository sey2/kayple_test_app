final class PostReqDto {
  const PostReqDto({
    required this.id,
    required this.title,
    required this.body,
    required this.isFavorite,
  });

  final int id;
  final String title;
  final String body;
  final bool isFavorite;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'title': title, 'body': body};
  }
}
