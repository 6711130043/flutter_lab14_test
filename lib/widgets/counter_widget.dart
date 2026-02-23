import 'package:flutter/material.dart';

/// Simple Counter Widget for widget testing demonstration
class CounterWidget extends StatefulWidget {
  final int initialCount;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const CounterWidget({
    super.key,
    this.initialCount = 0,
    this.onIncrement,
    this.onDecrement,
  });

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  late int _count;

  @override
  void initState() {
    super.initState();
    _count = widget.initialCount;
  }

  void _increment() {
    setState(() => _count++);
    widget.onIncrement?.call();
  }

  void _decrement() {
    setState(() => _count--);
    widget.onDecrement?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'จำนวนปุ่มที่กด',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Text(
            '$_count',
            key: const Key('counter_text'),
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                key: const Key('decrement_button'),
                onPressed: _decrement,
                tooltip: 'ลด',
                child: const Icon(Icons.remove),
              ),
              const SizedBox(width: 16),
              FloatingActionButton(
                key: const Key('increment_button'),
                onPressed: _increment,
                tooltip: 'เพิ่ม',
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
