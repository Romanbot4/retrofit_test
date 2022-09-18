import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import 'models/post.dart';

part 'rest.g.dart';

@RestApi(baseUrl: "https://jsonplaceholder.typicode.com/")
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  static RestClient create() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    return RestClient(dio);
  }

  @GET("/posts")
  Future<List<Post>> getPosts();

  @GET("/comments/{postId}")
  Future<Comment> getCommentByPostId(@Path("postId") int postId);

  @POST("/posts")
  Future<Post> createPost(@Body() Post post);
}
