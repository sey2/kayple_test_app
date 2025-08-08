import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kayple_test/core/utils/result.dart';
import 'package:kayple_test/core/utils/result_extension.dart';
import 'package:kayple_test/domain/post/entity/post_entity.dart';
import 'package:kayple_test/domain/post/repository/post_repository.dart';
import 'package:kayple_test/presenter/base/base_state.dart';

final class PostListViewModel with ChangeNotifier {
  PostListViewModel({required this.postRepository}) {
    init();
  }

  List<PostEntity> postList = [];
  final BaseState postListState = BaseState();

  final PostRepository postRepository;
  late final StreamSubscription<PostEntity> _postSubscription;

  Future<void> init() async {
    postListState.state = StateEnum.loading;
    Result<List<PostEntity>> result = await postRepository.getPosts();

    // 좋아요 변화 구독
    // 화면간 데이터 일관성
    _postSubscription = postRepository.favoritePostController.stream.listen((
      postEntity,
    ) {
      postList =
          (postList.isEmpty)
              ? []
              : postList.map((post) {
                return post.id == postEntity.id ? postEntity : post;
              }).toList();
      notifyListeners();
    });

    result.when(
      ok: (data) {
        postList = data;
        postListState.state = StateEnum.success;
      },
      failure: (error) {
        postListState.state = StateEnum.error;
        postListState.errorMessage = error.toString();
      },
    );
    notifyListeners();
  }

  Future<void> toggleFavorite(PostEntity postEntity) async {
    await postRepository.setFavorite(postEntity);
  }

  @override
  void dispose() {
    _postSubscription.cancel();
    super.dispose();
  }
}
