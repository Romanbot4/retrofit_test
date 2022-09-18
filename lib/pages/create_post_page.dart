import 'package:flutter/material.dart';
import 'package:retro_app/network/models/post.dart';

class CreatePostPage extends StatefulWidget {
  final void Function(Post)? onDone;
  const CreatePostPage({
    Key? key,
    this.onDone,
  }) : super(key: key);

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  late ThemeData theme;
  final formKey = GlobalKey<FormState>();

  late TextEditingController postIdControl,
      userIdControl,
      bodyControl,
      titleControl;

  @override
  void initState() {
    super.initState();
    postIdControl = TextEditingController(text: "1");
    userIdControl = TextEditingController(text: "1");
    bodyControl = TextEditingController(text: "KPP Test");
    titleControl = TextEditingController(
      text:
          "This is a test run by kpp at time ${DateTime.now().toIso8601String()}",
    );
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(widget.key.toString()),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                validator: (text) {
                  dismissKeyBoard(context);
                  if (text == null && text!.isEmpty) {
                    return "This field seem to be emtpy";
                  }
                  if (!RegExp('[0-9]+').hasMatch(text)) {
                    return "Enter Valid Name";
                  }
                  return null;
                },
                controller: userIdControl,
                style: theme.textTheme.titleMedium,
                decoration: const InputDecoration(
                  label: Text("User's Id"),
                  hintText: "user id...",
                ),
              ),
              TextFormField(
                validator: (text) {
                  dismissKeyBoard(context);
                  if (text == null && text!.isEmpty) {
                    return "This field seem to be emtpy";
                  }
                  if (!RegExp('[0-9]+').hasMatch(text)) {
                    return "Enter Valid Name";
                  }
                  return null;
                },
                controller: postIdControl,
                style: theme.textTheme.titleMedium,
                decoration: const InputDecoration(
                  label: Text("Post Id"),
                  hintText: "post id...",
                ),
              ),
              TextFormField(
                validator: (text) {
                  dismissKeyBoard(context);
                  if (text == null && text!.isEmpty) {
                    return "This field seem to be emtpy";
                  }
                  return null;
                },
                controller: titleControl,
                style: theme.textTheme.titleMedium,
                decoration: const InputDecoration(
                  label: Text("Title"),
                  hintText: "title...",
                ),
              ),
              TextFormField(
                validator: (text) {
                  dismissKeyBoard(context);
                  if (text == null && text!.isEmpty) {
                    return "This field seem to be emtpy";
                  }
                  return null;
                },
                controller: bodyControl,
                style: theme.textTheme.titleMedium,
                decoration: const InputDecoration(
                  label: Text("Body"),
                  hintText: "body...",
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!mounted || !formKey.currentState!.validate()) return;
          widget.onDone?.call(
            Post(
              userId: int.parse(userIdControl.text),
              id: int.parse(postIdControl.text),
              title: titleControl.text,
              body: bodyControl.text,
            ),
          );
        },
        child: const Icon(Icons.done),
      ),
    );
  }

  void dismissKeyBoard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
