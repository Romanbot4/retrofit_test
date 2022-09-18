import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:retro_app/network/rest.dart';

import 'pages/home_page.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const appName = "Retrofit Test";

  @override
  Widget build(BuildContext context) {
    final restClient = RestClient.create();

    return MultiProvider(
      providers: [Provider(create: (_) => restClient)],
      child: MaterialApp(
        title: appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(
          key: Key(appName),
        ),
      ),
    );
  }
}
