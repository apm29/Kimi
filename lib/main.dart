import 'package:flutter/material.dart';
import 'package:flutter_office/model/api.dart';
import 'package:flutter_office/ui/pages/splash.dart';
import 'package:stack_trace/stack_trace.dart';

void main(){
  initDio();
  Chain.capture((){runApp(new MyApp());},onError:(e,chain){
    print("Caught error $e\n"
              "${chain.terse}");
  });
}

///color
const int _goldPrimaryValue = 0xFFD7B47D;
const MaterialColor gold = const MaterialColor(
  _goldPrimaryValue,
  const <int, Color>{
    50: const Color(0xCCD7B47D),
    100: const Color(0xCCD7B47D),
    200: const Color(0xFFF1B47D),
    300: const Color(0xFFF1B47D),
    400: const Color(0xFFD7B47D),
    500: const Color(_goldPrimaryValue),
    600: const Color(0xFFBA9C68),
    700: const Color(0xFFBA9C68),
  },
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new SplashPage(),
      routes: <String, WidgetBuilder>{
        '/splash': (BuildContext context) => new SplashPage(),
      },
    );
  }
}
