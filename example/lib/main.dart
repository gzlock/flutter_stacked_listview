import 'dart:ui';

import 'package:flutter/material.dart';

import 'deletable_list.dart';
import 'normal_list.dart';

// Use the mouse scroll listview for windows
const Set<PointerDeviceKind> _kTouchLikeDeviceTypes = <PointerDeviceKind>{
  PointerDeviceKind.touch,
  PointerDeviceKind.mouse,
  PointerDeviceKind.stylus,
  PointerDeviceKind.invertedStylus,
  PointerDeviceKind.unknown
};

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      scrollBehavior: MaterialScrollBehavior().copyWith(
        scrollbars: true,
        dragDevices: _kTouchLikeDeviceTypes,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stacked ListView Example')),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Try to modify the \'fadeOutFrom\' and \'widthFactor\' or \'heightFactor\' parameters in the following example.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                    'The "widthFactor" is about the stacked width for each children'),
                Text(
                    'The "heightFactor" is about the stacked height for each children'),
                Text(
                    'The "fadeOutFrom" is about the first child widget how to fade out'),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: ListTile.divideTiles(
              context: context,
              tiles: [
                ListTile(
                  title: Text('Vertical listView'),
                  subtitle: Text('Can\'t swipe to remove item'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NormalListPage(
                        scrollDirection: Axis.vertical,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Vertical deletable listView'),
                  subtitle: Text('Swipe left or right to remove item'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DeletableListPage(
                        scrollDirection: Axis.vertical,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Horizontal listView'),
                  subtitle: Text('Can\'t swipe to remove item'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NormalListPage(
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Horizontal deletable listView'),
                  subtitle: Text('Swipe up or down to remove item'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DeletableListPage(
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ),
                ),
              ],
            ).toList(),
          ),
        ),
      ]),
    );
  }
}
