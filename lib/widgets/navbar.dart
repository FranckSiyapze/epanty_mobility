import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomTabs extends StatefulWidget {
  final int? selectedTab;
  final Function(int) tabPressed;
  BottomTabs({this.selectedTab, required this.tabPressed});

  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _selectedTab = 0;


  @override
  Widget build(BuildContext context) {
    _selectedTab = widget.selectedTab ?? 0;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18.0),
            topRight: Radius.circular(18.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 1.0,
              blurRadius: 30.0,
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomTabsBtn(
            icon: Icon(Icons.star),
            selected: _selectedTab == 0 ? true : false,
            onPressed: () {
              widget.tabPressed(0);
            },
          ),
          BottomTabsBtn(
            icon: Icon(Icons.map),
            selected: _selectedTab == 1 ? true : false,
            onPressed: () {
              widget.tabPressed(1);
            },
          ),
          BottomTabsBtn(
            icon: Icon(Icons.message),
            selected: _selectedTab == 2 ? true : false,
            onPressed: () {
              widget.tabPressed(2);
            },
          ),
        ],
      ),
    );
  }
}

class BottomTabsBtn extends StatelessWidget {
  final Icon icon;
  final bool? selected;
  final Function()? onPressed;
  BottomTabsBtn({required this.icon, this.selected, this.onPressed});
  @override
  Widget build(BuildContext context) {
    bool _selected = selected ?? false;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                  color: _selected ? Theme.of(context).accentColor : Colors.transparent,
                  width: 2.0,
                ))),
        child: icon
        /*Image(
          image: AssetImage(
            imagePath ?? "assets/tab/tab_home.png",
          ),
          height: 25.0,
          width: 25.0,
          color: _selected ? Theme.of(context).accentColor : Colors.black,
        ),*/
      ),
    );
  }
}
