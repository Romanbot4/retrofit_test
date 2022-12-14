import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retro_app/network/rest.dart';
import 'package:retro_app/pages/create_post_page.dart';

import '../network/models/post.dart';

const double cardR = 8;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late RestClient restClient;
  late ThemeData theme;
  double h = 0, w = 0;

  List<Post> posts = [];
  List<Comment> commets = [];

  Future<void> refreshData() async {
    try {
      posts = await restClient.getPosts();
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    restClient = context.watch<RestClient>();
    theme = Theme.of(context);
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Retrofit Pub Test"),
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: Container(
          alignment: Alignment.center,
          child: FutureBuilder<List<Post>>(
            future: restClient.getPosts(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.done) {
                if (!snap.hasData || snap.hasError || snap.data == null) {
                  return errorCard();
                }
                posts = snap.data!;
                return postCards(posts);
              }
              return progressWidget();
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_rounded),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CreatePostPage(
              key: const Key("Create Post"),
              onDone: (post) async {
                await restClient.createPost(post).then((post) async {
                  log(post.toJson().toString());
                  Navigator.pop(context);
                });
              },
            );
          }));
        },
      ),
    );
  }

  Widget postCards(List<Post> posts) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: [...posts.map(postWidget)],
    );
  }

  Widget postWidget(Post post) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardR)),
      child: Padding(
        padding: const EdgeInsets.all(cardR),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: const Icon(Icons.face_rounded),
                ),
                const SizedBox(width: cardR),
                Text(
                  "user_${post.userId}",
                  style: theme.textTheme.titleMedium,
                )
              ],
            ),
            Text(
              post.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              post.body,
              style: theme.textTheme.bodyMedium,
            ),
            const Divider(),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const CircleAvatar(
                    child: Icon(Icons.thumb_up_alt_rounded),
                  ),
                ),
                const SizedBox(width: cardR),
                IconButton(
                  onPressed: () => showComments(post.id),
                  icon: const CircleAvatar(
                    child: Icon(Icons.comment_rounded),
                  ),
                ),
                const SizedBox(width: cardR),
                IconButton(
                  onPressed: () {},
                  icon: const CircleAvatar(
                    child: Icon(Icons.share),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showComments(int postId) async {
    showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(cardR)),
      ),
      context: context,
      builder: (_) {
        return Container(
          width: w,
          height: h * 0.5,
          decoration: const BoxDecoration(),
          padding: const EdgeInsets.all(cardR),
          child: FutureBuilder<Comment>(
            future: restClient.getCommentByPostId(postId),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.done) {
                if (!snap.hasData || snap.hasError || snap.data == null) {
                  return errorCard();
                }
                commets = [snap.data!];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Comments',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      flex: 1,
                      child: ListView(
                        children: [...commets.map(commentWidget)],
                      ),
                    )
                  ],
                );
              }
              return progressWidget();
            },
          ),
        );
      },
    );
  }

  Widget progressWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: const [
        SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }

  Widget commentWidget(Comment comment) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: '${comment.name}\n',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
            children: [
              TextSpan(
                text: comment.email,
                style: theme.textTheme.titleMedium,
              )
            ],
          ),
          textAlign: TextAlign.justify,
        ),
        Text(
          comment.body,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget errorCard() {
    return Center(
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.red,
          ),
          Text(
            "Something went wrong!",
            style: theme.textTheme.titleMedium,
          )
        ],
      ),
    );
  }
}
