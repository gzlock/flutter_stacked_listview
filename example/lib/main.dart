import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'deletable.dart';
import 'horizontal.dart';
import 'horizontalDeletable.dart';
import 'normal.dart';

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
        Text(
            'You can try to modify the \'fadeOutFrom\' and \'widthFactor\' or \'heightFactor\' parameters in the following example.'),
        Text('The "widthFactor" is about the stacked width for each children'),
        Text(
            'The "heightFactor" is about the stacked height for each children'),
        Text(
            'The "fadeOutFrom" is about the first child widget how to fade out'),
        Expanded(
          child: ListView(
            children: ListTile.divideTiles(
              context: context,
              tiles: [
                ListTile(
                  title: Text('Normal vertical listView'),
                  subtitle: Text('Unable slide to delete item.'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NormalListPage(),
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Vertical deletable listView'),
                  subtitle: Text('Slide to left or right to delete item.'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DeletableListPage(),
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Normal horizontal listView'),
                  subtitle: Text('Unable slide to delete item.'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NormalHorizontalListPage(),
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Horizontal deletable listView'),
                  subtitle: Text('Slide to up or down to delete item.'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HorizontalDeletableListPage(),
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
