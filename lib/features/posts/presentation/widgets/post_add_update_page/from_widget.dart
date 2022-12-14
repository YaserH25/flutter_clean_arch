import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_arch/features/posts/domain/entities/post.dart';
import 'package:flutter_clean_arch/features/posts/presentation/bloc/add_delete_update_post/add_delete_update_posts_bloc.dart';

class FormWidget extends StatefulWidget {
  final bool isUpdatePost;
  final Post? post;
  const FormWidget({super.key, required this.isUpdatePost, this.post});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    if (widget.isUpdatePost) {
      _titleController.text = widget.post!.title;
      _bodyController.text = widget.post!.body;
    }

    super.initState();
  }

  void ValidateFormThenUpdateOrAddPost() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final post = Post(
          id: widget.isUpdatePost ? widget.post!.id : null,
          title: _titleController.text,
          body: _bodyController.text);
      if (widget.isUpdatePost) {
        BlocProvider.of<AddDeleteUpdatePostsBloc>(context)
            .add(UpdatePostEvent(post: post));
      } else {
        BlocProvider.of<AddDeleteUpdatePostsBloc>(context)
            .add(AddPostEvent(post: post));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextFormField(
                controller: _titleController,
                validator: (val) =>
                    val!.isEmpty ? "Title Can't Be Empty" : null,
                decoration: InputDecoration(hintText: "Title"),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: TextFormField(
                controller: _bodyController,
                validator: (val) => val!.isEmpty ? "Body Can't Be Empty" : null,
                decoration: InputDecoration(hintText: "Body"),
                minLines: 6,
                maxLines: 10,
              ),
            ),
            ElevatedButton.icon(
              onPressed: ValidateFormThenUpdateOrAddPost,
              icon: widget.isUpdatePost ? Icon(Icons.edit) : Icon(Icons.add),
              label: Text(widget.isUpdatePost ? "Update" : "Add"),
            )
          ]),
    );
  }
}
