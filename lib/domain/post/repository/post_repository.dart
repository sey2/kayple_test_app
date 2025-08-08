import 'dart:async';

import 'package:kayple_test/core/utils/result.dart';
import 'package:kayple_test/domain/post/entity/post_entity.dart';

abstract interface class PostRepository {
  Future<Result<List<PostEntity>>> getPosts();
  Future<Result<PostEntity>> getPost(int id);
  Future<void> setFavorite(PostEntity postEntity);
  StreamController<PostEntity> get favoritePostController;
}
