import 'package:flutter/cupertino.dart';

class Todos {
  final String? id;
  final String? title;
  final bool? isChecked;
  bool isEditing;
  FocusNode? focusnode;
  TextEditingController? controller;

  Todos({this.id, this.title, this.isChecked, this.isEditing = false, this.focusnode,this.controller});
}