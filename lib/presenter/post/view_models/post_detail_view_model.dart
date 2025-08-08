import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:kayple_test/core/utils/result.dart';
import 'package:kayple_test/core/utils/result_extension.dart';
import 'package:kayple_test/domain/post/entity/post_entity.dart';
import 'package:kayple_test/domain/post/repository/post_repository.dart';
import 'package:kayple_test/presenter/base/base_state.dart';

final class PostDetailViewModel with ChangeNotifier {
  PostDetailViewModel({
    required this.id,
    required this.postRepository,
    this.postEntity,
  }) {
    init();
  }

  final int id;
  late PostEntity? postEntity;
  final BaseState postDetailState = BaseState();
  final PostRepository postRepository;
  late final StreamSubscription<PostEntity> _postSubscription;

  Future<void> init() async {
    postDetailState.state = StateEnum.loading;

    // 좋아요 변화 구독
    // 화면간 데이터 일관성
    _postSubscription = postRepository.favoritePostController.stream.listen((
      newPostEntity,
    ) {
      postEntity = newPostEntity;
      notifyListeners();
    });

    if (postEntity != null) {
      postDetailState.state = StateEnum.success;
      return;
    }

    // postEntity가 null인 경우는 웹에서 주소 창으로 직접 쳐서 들어올 경우
    // 이 경우에만 api 호출
    Result<PostEntity> result = await postRepository.getPost(id);

    result.when(
      ok: (data) {
        postEntity = data;
        postDetailState.state = StateEnum.success;
      },
      failure: (error) {
        postDetailState.errorMessage = error.toString();
        postDetailState.state = StateEnum.error;
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
