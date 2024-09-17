import 'package:flutter/material.dart';
import 'package:premixer/models/source_model.dart';

class SourceTag extends StatelessWidget {
  final SourceModel src;

  const SourceTag({
    super.key,
    required this.src,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black45,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(src.name));
  }
}
