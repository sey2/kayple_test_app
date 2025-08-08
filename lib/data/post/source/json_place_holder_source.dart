import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:kayple_test/core/utils/result.dart';
import 'package:kayple_test/data/post/dto/post_res_dto.dart';
import 'package:kayple_test/domain/post/entity/post_entity.dart';

// 백엔드 API 변동이 없다는 가정하에 구현체만 구현
final class JsonPlaceHolderPostDataSource {
  final Client _client = http.Client();
  static const _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<Result<List<PostResDto>>> getPosts() async {
    try {
      final Response response = await _client.get(Uri.parse('$_baseUrl/posts'));

      _checkStatusCode(response.statusCode);

      final List<dynamic> jsonResponse = jsonDecode(response.body);
      final List<PostResDto> postDtoList =
          jsonResponse.map((json) => PostResDto.fromJson(json)).toList();

      return Result.ok(postDtoList);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  Future<Result<PostResDto>> getPost(int id) async {
    try {
      final Response response = await _client.get(
        Uri.parse('$_baseUrl/posts/$id'),
      );

      _checkStatusCode(response.statusCode);

      final Map<String, dynamic> json = jsonDecode(response.body);
      final PostResDto post = PostResDto.fromJson(json);

      return Result.ok(post);
    } on Exception catch (e) {
      return Result.failure(e);
    }
  }

  // 실제 서버 API가 없으므로 Mock 데이터를 반환
  Future<Result<PostResDto>> setFavorite(PostEntity postEntity) async {
    return Result.ok(
      PostResDto(
        userId: postEntity.id,
        id: postEntity.id,
        title: postEntity.title,
        body: postEntity.body,
        isFavorite: !postEntity.isFavorite,
      ),
    );
  }

  void _checkStatusCode(int statusCode) {
    if (statusCode < 200 && statusCode < 300) {
      throw Exception("Http Status Code: $statusCode");
    }
  }
}
