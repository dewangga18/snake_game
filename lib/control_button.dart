import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final void Function() onpressed;
  final Icon icon;

  const ControlButton({
    Key? key,
    required this.onpressed,
    required this.icon,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1,
      child: SizedBox(
        width: 60.0,
        height: 60.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Colors.black.withOpacity(0.5),
            elevation: 0,
            onPressed: onpressed,
            child: icon,
          ),
        ),
      ),
    );
  }
}
