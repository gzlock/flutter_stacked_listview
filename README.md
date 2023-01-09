# A Stacked ListView

# Video
[![](https://raw.githubusercontent.com/gzlock/images/master/flutter_stacked_listview/video.png)](https://youtu.be/B-U6BHam16I)

## v1.0.4 Breaking Change
 * **onRemove(int index)** changed to **onRemove(int index, AxisDirection dir)**
 * **beforeRemove(int index)** changed to **beforeRemove(int index, AxisDirection dir)**

### 🎉🎉 Yes, Now you can know the user's swipe direction for each list item 🎉🎉


## Install
```flutter pub add stacked_listview```

Example code:
```dart
Scaffold(
  appBar: AppBar(),
  backgroundColor: Colors.black,
  body: SafeArea(
    child: StackedListView(
      padding: EdgeInsets.only(left: 20, right: 20, top: 50),
      itemCount: data.length,
      itemExtent: itemHeight,
      heightFactor: 0.7,
      fadeOutFrom: 0.7,
      onRemove: (index, direction) {
        setState(() {
          data.removeAt(index);
        });
      },
      beforeRemove: (index, direction) async {
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
```