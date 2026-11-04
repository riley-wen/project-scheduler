import 'package:flutter/material.dart';

class UnknownPage extends StatelessWidget {
  const UnknownPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      alignment: Alignment.center,
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        children: [
          Text(
            "No page found...",
            textScaler: TextScaler.linear(0.6),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.none,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context), 
            icon: Icon(Icons.arrow_back),
          )
        ],
      )
      );
  }
}
