import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  const CircleButton(this.icon, this.color, this.onTap, {super.key});
  final IconData icon;
  final Color color;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
         const CircleBorder(),
        ),
      ),
      onPressed: onTap,
      child: Ink(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.amberAccent),
            shape: BoxShape.circle),
        child: Icon(
          icon,
          color: color,
          size: 35,
        ),
      ),
    );
  }
}
