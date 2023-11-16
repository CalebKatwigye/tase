import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final void Function()? onTap;
  const DeleteButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 65),
      child: GestureDetector(
        onTap: onTap,
        child: const Icon(Icons.delete, color: Colors.red,),
      ),
    );
  }
}