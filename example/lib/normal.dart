import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked_listview/stacked_listview.dart';

import 'data.dart';

class NormalListPage extends StatelessWidget {
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
          builder: (_, index) {
            return Container(
              width: itemHeight,
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
