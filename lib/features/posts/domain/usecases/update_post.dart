import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch/core/error/failures.dart';
import 'package:flutter_clean_arch/features/posts/domain/entities/post.dart';
import 'package:flutter_clean_arch/features/posts/domain/repositories/posts_repo.dart';

class UpdatePostUsercase {
  final PostsRepository repository;

  UpdatePostUsercase(this.repository);

  Future<Either<Failure, Unit>> call(Post post) async {
    return await repository.updatePost(post);
  }
}
