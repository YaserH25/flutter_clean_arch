import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_arch/features/posts/domain/entities/post.dart';

class PostListWidget extends StatelessWidget {
  final List<Post> posts;
  const PostListWidget({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: ((context, index) {
          return ListTile(
            leading: Text(posts[index].id.toString()),
            title: Text(
              posts[index].title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(posts[index].body, style: TextStyle(fontSize: 18)),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            onTap: () {},
          );
        }),
        separatorBuilder: ((context, index) => Divider(
              thickness: 1,
            )),
        itemCount: posts.length);
  }
}
