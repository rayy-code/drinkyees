import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget{

  const CustomTextfield({super.key, required this.label, required this.textController, required this.show, required this.type, this.onShow});

  final String label;

  final TextEditingController textController;

  final bool show;

  final String type;

  final void Function ()? onShow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: type == "text" ? TextFormField(
        controller: textController,
        decoration: InputDecoration(
          label: Text(
            label,
            style: const TextStyle(
              color: Color(0xffC0C0C0)
            ),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffC0C0C0))
          ) 
        ),
      ) :
      TextFormField(
        controller: textController,
        obscureText: show,
        decoration: InputDecoration(
          // suffixIcon: IconButton(
          //   icon: Icon( show ?Icons.visibility:Icons.visibility_off),
          //   onPressed: () {
          //    onShow!();
              
          //   }
          // ),
          label: Text(
            label,
            style: const TextStyle(
              color: Color(0xffC0C0C0)
            ),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffC0C0C0))
          ) 
        ),
      ),
    );
  }
}