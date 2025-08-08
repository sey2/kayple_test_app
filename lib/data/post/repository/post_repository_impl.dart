import 'dart:async';

import 'package:kayple_test/core/utils/result.dart';
import 'package:kayple_test/core/utils/result_extension.dart';
import 'package:kayple_test/data/post/dto/post_res_dto.dart';
import 'package:kayple_test/data/post/source/json_place_holder_source.dart';
import 'package:kayple_test/domain/post/entity/post_entity.dart';
import 'package:kayple_test/domain/post/repository/post_repository.dart';

final class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl._internal(this.remotePostDataSource);

  factory PostRepositoryImpl({
    required JsonPlaceHolderPostDataSource remotePostDataSource,
  }) {
    return _instance ??= PostRepositoryImpl._internal(remotePostDataSource);
  }

  static PostRepositoryImpl? _instance;

  final JsonPlaceHolderPostDataSource remotePostDataSource;
  final StreamController<PostEntity> _postStreamController =
      StreamController<PostEntity>.broadcast();

  @override
  Future<Result<List<PostEntity>>> getPosts() async {
    Result<List<PostResDto>> postResponse =
        await remotePostDataSource.getPosts();

    return postResponse.when(
      ok: (final List<PostResDto> posts) {
        final List<PostEntity> postList =
            posts.map((post) => post.toEntity()).toList();

        return Result.ok(postList);
      },
      failure: (final Exception e) {
        return Result.failure(e);
      },
    );
  }

  @override
  Future<Result<PostEntity>> getPost(int id) async {
    Result<PostResDto> postResponse = await remotePostDataSource.getPost(id);

    return postResponse.when(
      ok: (final PostResDto post) {
        _postStreamController.add(post.toEntity());
        return Result.ok(post.toEntity());
      },
      failure: (final Exception e) {
        return Result.failure(e);
      },
    );
  }

  @override
  Future<void> setFavorite(PostEntity postEntity) async {
    Result<PostResDto> postResponse = await remotePostDataSource.setFavorite(
      postEntity,
    );

    return postResponse.when(
      ok: (final PostResDto post) {
        _postStreamController.add(post.toEntity());
      },
      failure: (final Exception e) {
        _postStreamController.addError(e);
      },
    );
  }

  @override
  StreamController<PostEntity> get favoritePostController =>
      _postStreamController;
}
