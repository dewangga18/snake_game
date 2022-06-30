import 'package:_snake_game/control_button.dart';
import 'package:flutter/material.dart';

import 'package:_snake_game/direction.dart';

class ControlPanel extends StatelessWidget {
  final Function(Direction direction) onTapped;

  const ControlPanel({
    Key? key,
    required this.onTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0.0,
      right: 0.0, 
      bottom: 50.0,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                ControlButton(
                  onpressed: () {
                    onTapped(Direction.left);
                  }, 
                icon: const Icon(Icons.arrow_left, size: 45),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          Column(
            children: [
              ControlButton(
                onpressed: () {
                  onTapped(Direction.up);
                }, 
                icon: const Icon(Icons.arrow_drop_up, size: 45),
              ),
              const SizedBox(height: 40),
              ControlButton(
                onpressed: (){
                  onTapped(Direction.down);
                }, 
                icon: const Icon(Icons.arrow_drop_down, size: 45),
              ),
            ],
          ),
          Expanded(
            child: Row(
              children: [
                const SizedBox(width: 10),
                ControlButton(
                  onpressed: (){
                    onTapped(Direction.right);
                  }, 
                  icon: const Icon(Icons.arrow_right, size: 45),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
