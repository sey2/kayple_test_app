import 'package:flutter/material.dart';
import 'package:kayple_test/data/post/repository/post_repository_impl.dart';

import 'package:kayple_test/domain/post/entity/post_entity.dart';
import 'package:kayple_test/presenter/base/base_state.dart';
import 'package:kayple_test/presenter/post/view_models/post_detail_view_model.dart';
import 'package:provider/provider.dart';

final class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({
    super.key,
    required this.postId,
    required this.postEntity,
  });

  final int postId;
  final PostEntity? postEntity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ChangeNotifierProvider(
        create: (context) {
          return PostDetailViewModel(
            id: postId,
            postEntity: postEntity,
            postRepository: context.read<PostRepositoryImpl>(),
          );
        },
        builder: (context, child) {
          final postDetailState = context
              .select<PostDetailViewModel, StateEnum>((viewModel) {
                return viewModel.postDetailState.state;
              });

          switch (postDetailState) {
            case StateEnum.initial:
              return const Center(child: Text('Welcome to the Post List'));
            case StateEnum.loading:
              return const Center(child: CircularProgressIndicator());
            case StateEnum.error:
              final errorMessage =
                  context
                      .read<PostDetailViewModel>()
                      .postDetailState
                      .errorMessage;

              return Center(child: Text('Error: $errorMessage'));
            case StateEnum.success:
              {
                final postEntity = context
                    .select<PostDetailViewModel, PostEntity>((vm) {
                      return vm.postEntity!;
                    });

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(postEntity.title),
                    SizedBox(height: 24),
                    Text(postEntity.body),
                    SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {
                        context.read<PostDetailViewModel>().toggleFavorite(
                          postEntity,
                        );
                      },
                      child: Icon(
                        Icons.favorite,
                        size: 12,
                        color:
                            postEntity.isFavorite ? Colors.red : Colors.black,
                      ),
                    ),
                  ],
                );
              }
          }
        },
      ),
    );
  }
}
