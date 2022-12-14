import 'package:flutter_clean_arch/core/error/exeption.dart';
import 'package:flutter_clean_arch/core/network/network_info.dart';
import 'package:flutter_clean_arch/features/posts/data/datasources/post_locale_date_source.dart';
import 'package:flutter_clean_arch/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:flutter_clean_arch/features/posts/data/models/post_model.dart';
import 'package:flutter_clean_arch/features/posts/domain/entities/post.dart';
import 'package:flutter_clean_arch/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch/features/posts/domain/repositories/posts_repo.dart';

typedef Future<Unit> DeleteOrUpdateOrAddPost();

class PostRepositoryImpl implements PostsRepository {
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource locateDataSource;
  final NetworkInfo networkInfo;

  PostRepositoryImpl(
      {required this.remoteDataSource,
      required this.locateDataSource,
      required this.networkInfo});
  @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDataSource.getAllPosts();
        locateDataSource.cachePosts(remotePosts);
        return Right(remotePosts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPosts = await locateDataSource.getCachedPosts();
        return Right(localPosts);
      } on EmptyCachException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addePost(Post post) async {
    final PostModel postModel =
        PostModel(id: post.id, title: post.title, body: post.body);

    return await _getMessage(() {
      return remoteDataSource.addPost(postModel);
    });
  }

  @override
  Future<Either<Failure, Unit>> deletePost(int id) async {
    return await _getMessage(() {
      return remoteDataSource.deletePost(id);
    });
  }

  @override
  Future<Either<Failure, Unit>> updatePost(Post post) async {
    final PostModel postModel =
        PostModel(id: post.id, title: post.title, body: post.body);

    return await _getMessage(() {
      return remoteDataSource.updatePost(postModel);
    });
  }

  Future<Either<Failure, Unit>> _getMessage(
      DeleteOrUpdateOrAddPost deleteOrUpdateOrAddPost) async {
    if (await networkInfo.isConnected) {
      try {
        deleteOrUpdateOrAddPost();
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
