library stacked_listview;

import 'dart:ui';

import 'package:flutter/widgets.dart';

class StackedListView extends StatefulWidget {
  final Axis scrollDirection;
  final bool reverse;
  final IndexedWidgetBuilder builder;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final int itemCount;
  final double itemExtent;

  /// 0.0 ~ 1.0
  final double fadeOutFrom;

  /// 0.0 ~ 1.0
  final double heightFactor;
  final void Function(int index)? onRemove;
  final Future<bool> Function(int index)? beforeRemove;

  const StackedListView({
    Key? key,
    required this.itemCount,
    required this.builder,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.controller,
    this.physics,
    required this.itemExtent,
    this.fadeOutFrom = 0.7,
    this.heightFactor = 0.7,
    this.onRemove,
    this.beforeRemove,
  })  : assert(fadeOutFrom >= 0 && fadeOutFrom <= 1),
        assert(heightFactor >= 0 && heightFactor <= 1),
        super(key: key);

  @override
  State<StatefulWidget> createState() => StackedListViewState();
}

class StackedListViewState extends State<StackedListView> {
  late final ScrollController controller;
  Map<dynamic, dynamic> output = {};

  @override
  void initState() {
    controller = widget.controller ?? ScrollController();
    controller.addListener(_update);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_update);
    super.dispose();
  }

  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final realHeight = widget.itemExtent * widget.heightFactor;
    final fadeOut = widget.fadeOutFrom == 1 ? 0 : 1.0 - widget.fadeOutFrom;
    return Stack(children: [
      ListView.builder(
          padding: widget.padding,
          controller: controller,
          itemCount: widget.itemCount,
          physics: widget.physics ?? BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            double scroll =
                ((controller.offset - index * realHeight) / realHeight);
            double currentScroll = scroll.clamp(0.0, 1.0);

            double opacity = 1.0;
            double y = 0;
            bool atTop = false;

            if (currentScroll > 0 || (index == 0 && controller.offset <= 0)) {
              /// 当前的item是否在最顶部
              if (currentScroll < 1) {
                atTop = true;
              }

              /// 计算透明度
              if (currentScroll >= widget.fadeOutFrom) {
                if (widget.fadeOutFrom == 1) {
                  opacity = 0;
                } else {
                  final fadeOut =
                      ((1 - currentScroll) / (1.0 - widget.fadeOutFrom))
                          .clamp(0.0, 1.0);
                  opacity = lerpDouble(0.0, 1.0, fadeOut)!;
                }
                // if (index == 0) print('$fadeOut');
              }

              /// 计算偏移
              y = (currentScroll * realHeight).roundToDouble();
            }
            opacity = opacity.clamp(0.0, 1.0);
            return AnimatedItemWidget(
              key: UniqueKey(),
              atTop: atTop,
              lastOne: index == (widget.itemCount - 1),
              index: index,
              offsetY: y,
              opacity: opacity,
              heightFactor: widget.heightFactor,
              onRemove: widget.onRemove,
              beforeRemove: widget.beforeRemove,
              child: widget.builder(context, index),
            );
          }),
    ]);
  }
}

class AnimatedItemWidget extends StatefulWidget {
  final int index;
  final bool atTop, lastOne;
  final double opacity;
  final double offsetY;
  final double heightFactor;
  final Widget child;
  final void Function(int index)? onRemove;
  final Future<bool> Function(int index)? beforeRemove;

  const AnimatedItemWidget({
    Key? key,
    required this.atTop,
    required this.lastOne,
    required this.index,
    required this.offsetY,
    required this.opacity,
    required this.heightFactor,
    required this.child,
    this.onRemove,
    this.beforeRemove,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AnimatedItemWidget();
}

class _AnimatedItemWidget extends State<AnimatedItemWidget>
    with TickerProviderStateMixin {
  late final AnimationController animationController = AnimationController(
    duration: Duration(milliseconds: 100),
    vsync: this,
  );
  late final bool deletable = widget.onRemove != null;
  Animation<double>? animation;
  double offsetX = 0;
  bool confirmDelete = false;

  @override
  void dispose() {
    animationController.stop();
    super.dispose();
  }

  update() {
    offsetX = animation?.value ?? 0;
    setState(() {});
  }

  animationStatus(AnimationStatus status) {
    // print('animationStatus $confirmDelete');
    if (confirmDelete) widget.onRemove?.call(widget.index);
  }

  animateXTo(double end) {
    animationController
      ..stop()
      ..reset();
    animation =
        Tween<double>(begin: offsetX, end: end).animate(animationController);
    animationController.forward();
    (animation!).addListener(update);
    (animation!).addStatusListener(animationStatus);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        return GestureDetector(
          onHorizontalDragStart: deletable
              ? (_) {
                  animationController..stop();
                  animation?.removeListener(update);
                  animation?.removeStatusListener(animationStatus);
                  // print('start $offsetX');
                }
              : null,
          onHorizontalDragUpdate: deletable
              ? (DragUpdateDetails details) {
                  offsetX += details.delta.dx;
                  // print('update $offsetX');
                  setState(() {});
                }
              : null,
          onHorizontalDragEnd: deletable
              ? (DragEndDetails details) async {
                  final screenWidth = MediaQuery.of(context).size.width;
                  double end = 0;
                  if (offsetX < -width / 2.0) {
                    end = -screenWidth;
                  } else if (offsetX > (screenWidth / 2.0)) {
                    end = screenWidth;
                  }
                  if (end != 0) {
                    confirmDelete =
                        await widget.beforeRemove?.call(widget.index) ?? true;
                    if (!confirmDelete) end = 0;
                  }
                  animateXTo(end);
                }
              : null,
          child: Transform(
            alignment: Alignment.topCenter,
            transform: Matrix4.identity()..translate(offsetX, widget.offsetY),
            child: Opacity(
              opacity: widget.opacity,
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: widget.lastOne ? 1.0 : widget.heightFactor,
                child: SizedBox(
                  width: double.infinity,
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
