import 'package:flutter/material.dart';

Widget wgTextField (TextEditingController textController, String type, String label, bool isPassword, {Function? onShowPassword}) 
{
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
        obscureText: isPassword,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon( isPassword ?Icons.visibility:Icons.visibility_off),
            onPressed: () {
             onShowPassword!();
            }
          ),
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