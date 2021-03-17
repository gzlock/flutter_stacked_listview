import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked_listview/stacked_listview.dart';

import 'data.dart';

class DeletableListPage extends StatefulWidget {
  @override
  State createState() => _DeletableListPage();
}

class _DeletableListPage extends State<DeletableListPage> {
  final data = List.from(Data);
  final double itemHeight = 400;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: StackedListView(
          padding: EdgeInsets.only(left: 20, right: 20, top: 50),
          itemCount: data.length,
          itemExtent: itemHeight,
          heightFactor: 0.7,
          fadeOutFrom: 0.7,
          onRemove: (index) {
            setState(() {
              data.removeAt(index);
            });
          },
          beforeRemove: (index) async {
            return await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Delete ${data[index]} ?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel')),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text('Delete'),
                  ),
                ],
              ),
            ).then((value) => value == true);
          },
          builder: (_, index) {
            return Container(
              width: double.infinity,
              height: itemHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data[index],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text('Slide to left or right to delete'),
                ],
              ),
              padding: EdgeInsets.all(20),
            );
          },
        ),
      ),
    );
  }
}
