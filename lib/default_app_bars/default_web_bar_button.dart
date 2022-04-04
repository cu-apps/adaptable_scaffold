import 'package:flutter/material.dart';

class DefaultWebBarButton extends StatelessWidget {
  const DefaultWebBarButton(
      {Key? key,
      required this.title,
      this.onPressed,
      this.fontSize = 18,
      this.width = 180,
      this.fixedWidth,
      this.buttonColor,
      this.textColor = Colors.white,
      this.hoverColor,
      this.fontWeight = FontWeight.w700,
      this.padding = const EdgeInsets.all(0)})
      : super(key: key);
  final String title;
  final double width;
  final VoidCallback? onPressed;
  final double fontSize;
  final double? fixedWidth;
  final Color? buttonColor;
  final Color? textColor;
  final Color? hoverColor;
  final EdgeInsets padding;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fixedWidth,
      child: Padding(
        padding: padding,
        child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) return hoverColor;
              return null; // Use the default value.
            }),
          ),
          child: Container(
            child: Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    color:
                        textColor ?? Theme.of(context).secondaryHeaderColor)),
          ),
        ),
      ),
    );
  }
}
