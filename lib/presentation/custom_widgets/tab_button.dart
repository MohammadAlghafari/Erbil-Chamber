import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  const TabButton(
      {Key key,
      @required this.text,
      @required this.selectedPage,
      @required this.pageNumber,
      @required this.onTap,
      @required this.horizontalValue,
      @required this.verticaleValue,})
      : super(key: key);

  final String text;
  final int selectedPage;
  final int pageNumber;
  final Function onTap;
  final double horizontalValue;
  final double verticaleValue;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(
          milliseconds: 1000,
        ),
        curve: Curves.fastLinearToSlowEaseIn,
        decoration: BoxDecoration(
          color: selectedPage == pageNumber
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(4.0),
        ),
        padding: EdgeInsets.symmetric(
            vertical: selectedPage == pageNumber ? verticaleValue: 0,
            horizontal: selectedPage == pageNumber ? horizontalValue : 0),
        margin: EdgeInsets.symmetric(
            vertical: selectedPage == pageNumber ? 0 : verticaleValue,
            horizontal: selectedPage == pageNumber ? 0 : horizontalValue),
        child: Text(
          text,
          style: TextStyle(
              color: selectedPage == pageNumber ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}