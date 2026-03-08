import 'package:flutter/cupertino.dart';
import 'package:app_proyect/models/semana_data.dart';

class PickerItem extends StatefulWidget {
  final List<SemanaData> semanas;
  final int initialIndex;
  final ValueChanged<int> onChanged;

  const PickerItem({
    super.key,
    required this.semanas,
    required this.initialIndex,
    required this.onChanged,
  });

  @override
  State<PickerItem> createState() => _PickerItemState();
}

class _PickerItemState extends State<PickerItem> {
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: CupertinoPicker(
        scrollController: _controller,
        itemExtent: 40,
        onSelectedItemChanged: widget.onChanged,
        children: widget.semanas
            .map((s) => Center(child: Text(s.rango)))
            .toList(),
      ),
    );
  }
}
