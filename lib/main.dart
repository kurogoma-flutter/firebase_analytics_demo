import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_analytics.dart';

Future<void> main() async {
  await Firebase.initializeApp();
}

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RoundedButton(
              text: 'sendEvent',
              onPressed: () {
                AnalyticsManager().sendEvent(
                  name: AnalyticsScreenId.HOME.screenName,
                  screenId: AnalyticsScreenId.HOME,
                  type: 'サンプルイベント',
                  url: 'https://www.google.com',
                  contentsId: '123456789',
                );
              },
            ),
            RoundedButton(
              text: 'sendScreenEvent',
              onPressed: () {
                AnalyticsManager().sendScreenEvent(
                  screenId: AnalyticsScreenId.FEATURE,
                  contentsId: 'aabbccdd',
                );
              },
            ),
            RoundedButton(
              text: 'sendButtonEvent',
              onPressed: () {
                AnalyticsManager().sendButtonEvent(
                  screenId: AnalyticsScreenId.FEATURE,
                  buttonName: AnalyticsButtonName.create,
                  type: AnalyticsButtonName.create.rawValue,
                  url: 'https://www.google.com',
                  contentsId: 'aabbccdd',
                );
              },
            ),
            RoundedButton(
              text: 'setUserInfo',
              onPressed: () {
                AnalyticsManager().setUserInfo(
                  userId: '123456789',
                );
              },
            ),
            RoundedButton(
              text: 'resetUserInfo',
              onPressed: () {
                AnalyticsManager().resetUserInfo();
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// イベント送信する角丸ボタン
///
/// [text] ボタンに表示するテキスト
///
/// [onPressed] ボタンを押下した時の処理
class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(text),
    );
  }
}
