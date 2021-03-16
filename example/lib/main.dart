import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'deletable.dart';
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
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'You can try to modify the \'heightFactor\' and \'fadeOutFrom\' parameters in the following example'),
                  Text(
                      'The "heightFactor" is about the stacked height for each children'),
                  Text(
                      'The "fadeOutFrom" is about the top child widget how to fade out'),
                ],
              ),
            ),
            ListTile(
              title: Text('A Normal Stacked ListView'),
              subtitle: Text('The children unable to slide.'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NormalListPage(),
                ),
              ),
            ),
            ListTile(
              title: Text('A Stacked ListView of deletable children'),
              subtitle: Text('Slide the children left or right to delete it.'),
              trailing: Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DeletableListPage(),
                ),
              ),
            ),
          ],
        ).toList(),
      ),
    );
  }
}
