import 'package:flutter/material.dart';
import 'package:kayple_test/data/post/repository/post_repository_impl.dart';
import 'package:kayple_test/domain/post/entity/post_entity.dart';
import 'package:kayple_test/presenter/base/base_state.dart';
import 'package:kayple_test/presenter/post/screens/post_detail_screen.dart';
import 'package:kayple_test/presenter/post/view_models/post_list_view_model.dart';
import 'package:provider/provider.dart';

final class PostListScreen extends StatelessWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _PostListArea());
  }
}

final class _PostListArea extends StatelessWidget {
  const _PostListArea();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (context) => PostListViewModel(
            postRepository: context.read<PostRepositoryImpl>(),
          ),
      builder: (context, child) {
        final postListState = context.select<PostListViewModel, StateEnum>((
          viewModel,
        ) {
          return viewModel.postListState.state;
        });

        switch (postListState) {
          case StateEnum.initial:
          case StateEnum.loading:
            return const Center(child: CircularProgressIndicator());
          case StateEnum.error:
            final errorMessage =
                context.read<PostListViewModel>().postListState.errorMessage;

            return Center(child: Text('Error: $errorMessage'));
          case StateEnum.success:
            {
              final postList = context
                  .select<PostListViewModel, List<PostEntity>>((
                    PostListViewModel viewModel,
                  ) {
                    return viewModel.postList;
                  });

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 14),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Post ${postList[index].title}'),
                    trailing: GestureDetector(
                      onTap: () {
                        context.read<PostListViewModel>().toggleFavorite(
                          postList[index],
                        );
                      },
                      child: Icon(
                        Icons.favorite,
                        size: 12,
                        color:
                            postList[index].isFavorite
                                ? Colors.red
                                : Colors.black,
                      ),
                    ),
                    subtitle: Text(postList[index].body),
                    onTap: () {
                      navigateToPostDetail(
                        context: context,
                        postEntity: postList[index],
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(color: Colors.grey.shade300, height: 1);
                },
                itemCount: postList.length,
              );
            }
        }
      },
    );
  }

  void navigateToPostDetail({
    required BuildContext context,
    required PostEntity postEntity,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                PostDetailScreen(postId: postEntity.id, postEntity: postEntity),
      ),
    );
  }
}
