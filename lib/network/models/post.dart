class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  //Keys
  static const _userIdKey = "userId";
  static const _postIdKey = "id";
  static const _titleKey = "title";
  static const _bodyKey = "body";

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json[_userIdKey],
      id: json[_postIdKey],
      title: json[_titleKey],
      body: json[_bodyKey],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _userIdKey: userId,
      _postIdKey: id,
      _titleKey: title,
      _bodyKey: body,
    };
  }
}

class Comment {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  Comment({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  //Keys
  static const _postIdKey = "postId";
  static const _commentIdKey = "id";
  static const _nameKey = "name";
  static const _emailKey = "email";
  static const _bodyKey = "body";

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      postId: json[_postIdKey],
      id: json[_commentIdKey],
      name: json[_nameKey],
      email: json[_emailKey],
      body: json[_bodyKey],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      _postIdKey: postId,
      _commentIdKey: id,
      _nameKey: name,
      _emailKey: email,
      _bodyKey: body,
    };
  }
}
