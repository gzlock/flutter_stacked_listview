import 'package:flutter/material.dart';
import 'package:stacked_listview/stacked_listview.dart';

import 'data.dart';

class NormalListPage extends StatelessWidget {
  final Axis scrollDirection;
  final data = List.from(Data);
  final double itemHeight = 400;

  NormalListPage({Key? key, required this.scrollDirection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: StackedListView(
          scrollDirection: scrollDirection,
          padding: EdgeInsets.all(20),
          itemCount: data.length,
          itemExtent: itemHeight,
          widthFactor: scrollDirection == Axis.vertical ? 1 : 0.7,
          heightFactor: scrollDirection == Axis.vertical ? 0.7 : 1,
          builder: (_, index) {
            return Container(
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
                    Data[index],
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
