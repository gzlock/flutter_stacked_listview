import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked_listview/stacked_listview.dart';

class NormalListPage extends StatelessWidget {
  final List<String> data = [
    'Burger',
    'Cheese Dip',
    'Cola',
    'Fries',
    'Ice Cream',
    'Noodles',
    'Pizza',
    'Sandwich',
    'Wrap',
  ];
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
          heightFactor: 1,
          fadeOutFrom: 1,
          beforeRemove: (index) async {
            return await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Confirm delete ${data[index]} ?'),
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
