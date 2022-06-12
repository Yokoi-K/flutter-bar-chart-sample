import 'package:flutter/material.dart';

class AppPage extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0, // $B:G=i$KI=<($9$k%?%V(B
      length: 3, // $B%?%V$N?t(B
      child: Scaffold(
        appBar: AppBar(
          title: const Text('$B%[!<%`(B'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: '$BLn5e(B'),
              Tab(text: '$B%5%C%+!<(B'),
              Tab(text: '$B%F%K%9(B'),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: Text('$BLn5e(B', style: TextStyle(fontSize: 32.0)),
            ),
            Center(
              child: Text('$B%5%C%+!<(B', style: TextStyle(fontSize: 32.0)),
            ),
            Center(
              child: Text('$B%F%K%9(B', style: TextStyle(fontSize: 32.0)),
            ),
          ],
        ),
      ),
    );
  }
}
