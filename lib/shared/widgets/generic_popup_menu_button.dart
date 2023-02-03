import 'package:flutter/material.dart';

class GenericPopUpMenuButton extends StatefulWidget {
  const GenericPopUpMenuButton({Key? key, required this.switchFunction, required this.popUpMenuItemList}) : super(key: key);

  final Function switchFunction;
  final List<PopupMenuItem> popUpMenuItemList;

  @override
  State<GenericPopUpMenuButton> createState() => _GenericPopUpMenuButtonState();
}

class _GenericPopUpMenuButtonState extends State<GenericPopUpMenuButton> {

  dynamic selectedMenu;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      initialValue: selectedMenu,
      onSelected: (item) async {
        widget.switchFunction(item);
      },
      itemBuilder: (BuildContext context) {
        return  widget.popUpMenuItemList;
      }
    );
  }
}
