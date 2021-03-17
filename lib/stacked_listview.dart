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

  /// Item count
  final int itemCount;

  /// When the [scrollDirection] equal Axis.vertical, it's be item height
  /// When the [scrollDirection] equal Axis.horizontal, it's be item width
  final double itemExtent;

  /// 0.0 ~ 1.0
  final double fadeOutFrom;

  /// 0.0 ~ 1.0
  final double heightFactor;

  /// 0.0 ~ 1.0
  final double widthFactor;

  /// After deleted item will trigger it
  final void Function(int index)? onRemove;

  /// Before delete item and return true will delete item
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
    this.heightFactor = 1,
    this.widthFactor = 1,
    this.onRemove,
    this.beforeRemove,
  })  : assert(fadeOutFrom >= 0 && fadeOutFrom <= 1,
            'The range of "fadeOutFrom" must be 0.0 ~ 1.0'),
        assert(widthFactor >= 0 && widthFactor <= 1,
            'The range of "widthFactor" must be 0.0 ~ 1.0'),
        assert(heightFactor >= 0 && heightFactor <= 1,
            'The range of "heightFactor" must be 0.0 ~ 1.0'),
        assert(widthFactor == 1 || heightFactor == 1,
            'One of "widthFactor" or "heightFactor" must equal 1'),
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
    final realExtent = widget.itemExtent *
        (widget.scrollDirection == Axis.horizontal
            ? widget.widthFactor
            : widget.heightFactor);
    return Stack(children: [
      ListView.builder(
          scrollDirection: widget.scrollDirection,
          padding: widget.padding,
          controller: controller,
          itemCount: widget.itemCount,
          physics: widget.physics ?? BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            double scroll =
                ((controller.offset - index * realExtent) / realExtent);
            double currentScroll = scroll.clamp(0.0, 1.0);

            double opacity = 1.0;
            double offset = 0;
            bool atFirst = false;

            if (currentScroll > 0 || (index == 0 && controller.offset <= 0)) {
              /// 当前的item是否在最顶部
              if (currentScroll < 1) {
                atFirst = true;
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
              offset = (currentScroll * realExtent).roundToDouble();
            }
            opacity = opacity.clamp(0.0, 1.0);
            return AnimatedItemWidget(
              key: UniqueKey(),
              scrollDirection: widget.scrollDirection,
              atFirst: atFirst,
              lastOne: index == (widget.itemCount - 1),
              index: index,
              offset: offset,
              opacity: opacity,
              widthFactor: widget.widthFactor,
              heightFactor: widget.heightFactor,
              onRemove: widget.onRemove,
              beforeRemove: widget.beforeRemove,
              child: SizedBox(
                width: widget.scrollDirection == Axis.vertical
                    ? double.infinity
                    : widget.itemExtent,
                height: widget.scrollDirection == Axis.vertical
                    ? widget.itemExtent
                    : double.infinity,
                child: widget.builder(context, index),
              ),
            );
          }),
    ]);
  }
}

class AnimatedItemWidget extends StatefulWidget {
  final int index;
  final bool atFirst, lastOne;
  final double opacity;
  final double offset;
  final double widthFactor, heightFactor;
  final Widget child;
  final Axis scrollDirection;
  final void Function(int index)? onRemove;
  final Future<bool> Function(int index)? beforeRemove;

  const AnimatedItemWidget({
    Key? key,
    required this.atFirst,
    required this.lastOne,
    required this.index,
    required this.offset,
    required this.opacity,
    required this.widthFactor,
    required this.heightFactor,
    required this.child,
    required this.scrollDirection,
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
  double _dragOffset = 0;
  bool confirmDelete = false;

  @override
  void dispose() {
    animationController.stop();
    super.dispose();
  }

  update() {
    _dragOffset = animation?.value ?? 0;
    setState(() {});
  }

  animationStatus(AnimationStatus status) {
    // print('animationStatus $confirmDelete');
    if (confirmDelete) widget.onRemove?.call(widget.index);
  }

  _animateTo(double end) {
    animationController
      ..stop()
      ..reset();
    animation = Tween<double>(begin: _dragOffset, end: end)
        .animate(animationController);
    animationController.forward();
    (animation!).addListener(update);
    (animation!).addStatusListener(animationStatus);
  }

  @override
  Widget build(BuildContext context) {
    Matrix4 transform;
    Alignment alignment;
    if (widget.scrollDirection == Axis.vertical) {
      alignment = Alignment.topCenter;
      transform = Matrix4.identity()..translate(_dragOffset, widget.offset);
    } else {
      alignment = Alignment.centerLeft;
      transform = Matrix4.identity()..translate(widget.offset, _dragOffset);
    }
    Widget child = Transform(
      alignment: alignment,
      transform: transform,
      child: Opacity(
        opacity: widget.opacity,
        child: Align(
          alignment: alignment,
          widthFactor: widget.lastOne ? 1.0 : widget.widthFactor,
          heightFactor: widget.lastOne ? 1.0 : widget.heightFactor,
          child: widget.child,
        ),
      ),
    );
    if (deletable) {
      // print('deletable ${widget.scrollDirection}');
      if (widget.scrollDirection == Axis.horizontal) {
        child = GestureDetector(
          onVerticalDragStart: _dragStart,
          onVerticalDragUpdate: _dragUpdate,
          onVerticalDragEnd: _dragEnd,
          child: child,
        );
      } else {
        child = GestureDetector(
          onHorizontalDragStart: _dragStart,
          onHorizontalDragUpdate: _dragUpdate,
          onHorizontalDragEnd: _dragEnd,
          child: child,
        );
      }
    }
    return child;
  }

  _dragStart(_) {
    animationController..stop();
    animation?.removeListener(update);
    animation?.removeStatusListener(animationStatus);
    // print('start $offsetX');
  }

  _dragUpdate(DragUpdateDetails details) {
    _dragOffset += widget.scrollDirection == Axis.vertical
        ? details.delta.dx
        : details.delta.dy;
    // print('update $_dragOffset');
    setState(() {});
  }

  _dragEnd(DragEndDetails details) async {
    final size = MediaQuery.of(context).size;
    final target =
        widget.scrollDirection == Axis.horizontal ? size.height : size.width;
    double end = 0;
    if (_dragOffset < -target / 2.0) {
      end = -target;
    } else if (_dragOffset > (target / 2.0)) {
      end = target;
    }
    if (end != 0) {
      confirmDelete = await widget.beforeRemove?.call(widget.index) ?? true;
      if (!confirmDelete) end = 0;
    }
    _animateTo(end);
  }
}
