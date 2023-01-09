import 'package:flutter/material.dart';
import 'package:stacked_listview/stacked_listview.dart';

import 'data.dart';

final _titleStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

class DeletableListPage extends StatefulWidget {
  final Axis scrollDirection;

  const DeletableListPage({Key? key, required this.scrollDirection})
      : super(key: key);

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
          scrollDirection: widget.scrollDirection,
          padding: EdgeInsets.all(20),
          itemCount: data.length,
          itemExtent: itemHeight,
          widthFactor: widget.scrollDirection == Axis.vertical ? 1 : 0.7,
          heightFactor: widget.scrollDirection == Axis.vertical ? 0.7 : 1,
          onRemove: (index, dir) {
            /// You can double check which item can remove
            setState(() {
              data.removeAt(index);
            });
          },
          beforeRemove: (index, dir) async {
            final item = data[index];

            /// [Burger] can not delete
            if (item == 'Burger') {
              return false;
            }

            /// Swipe to up or left can not remove [Cheese Dip]
            else if (item == 'Cheese Dip' &&
                [AxisDirection.up, AxisDirection.left].contains(dir)) {
              return false;
            }

            /// Delete other items after confirmation
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
            final item = data[index];
            Widget title, subTitle;
            if (item == 'Burger') {
              title = Text.rich(
                TextSpan(children: [
                  WidgetSpan(
                    child: Icon(Icons.lock_outline_rounded, color: Colors.red),
                  ),
                  TextSpan(text: data[index]),
                ]),
                style: _titleStyle,
              );
              subTitle = Text(
                'Burger cannot remove',
                style: TextStyle(color: Colors.red),
              );
            } else if (item == 'Cheese Dip') {
              title = Text(data[index], style: _titleStyle);
              final dir =
                  widget.scrollDirection == Axis.vertical ? 'right' : 'down';
              subTitle = Text(
                'Swipe $dir to remove',
                style: TextStyle(color: Colors.blue),
              );
            } else {
              title = Text(data[index], style: _titleStyle);
              subTitle = Text('Swipe to remove');
            }
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
                  title,
                  subTitle,
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
