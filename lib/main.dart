import 'package:flutter/material.dart';
import 'package:flutter_office/model/api.dart';
import 'package:flutter_office/text_style.dart';
import 'package:flutter_office/ui/pages/main.dart';
import 'package:flutter_office/ui/pages/splash.dart';
import 'package:stack_trace/stack_trace.dart';

void main() async{
  await initDio();
  Chain.capture(() {
    runApp(new MyApp());
  }, onError: (e, chain) {
    print("Caught error $e\n"
        "${chain.terse}");
  });
}

///color
const int _goldPrimaryValue = 0xFFD7B47D;
const MaterialColor gold = const MaterialColor(
  _goldPrimaryValue,
  const <int, Color>{
    50: const Color(0xCCFFF9C4),
    100: const Color(0xAEFFF9C4),
    200: const Color(0xFFF1B47D),
    300: const Color(0xFFF1A47D),
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
        primarySwatch: gold,
        textTheme: new TextTheme(
          display1: themeStyle1,
          display2: themeStyle2,
          display3: themeStyle3,
          display4: themeStyle4,
          headline: themeHeadlineStyle1,
          subhead: themeSubStyle,
          body1: themeBodyStyle1,
          body2: themeBodyStyle2,
          caption: themeCaptionStyle,
          button: themeButtonStyle,
          title: themeTitleStyle1,
        )
      ),
      home: new SplashPage(),
      routes: <String, WidgetBuilder>{
        '/splash': (BuildContext context) => new SplashPage(),
        '/main': (BuildContext context) => new MainPage(),
      },
    );
  }
}
