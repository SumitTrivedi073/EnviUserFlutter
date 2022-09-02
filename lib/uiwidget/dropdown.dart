import 'package:flutter/material.dart';

import '../theme/styles.dart';


class DropDownWidget extends StatelessWidget {
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Function(String)? onChange;
  final Color? backGroundColor;
  final BorderRadius? borderRadius;
  final TextStyle? style;
  final String? selectedValue;
  final String? hintText;
  final String? label;
  final List<String>? children;
  final Widget? endWidget;
  final double? height;
  final BoxBorder? border;
  final bool isMandate;
  final Color? dropdownColor;
  final double? iconSize;
 
  final AlignmentGeometry? dropDownAlignment;

  /// default value to show in the dropdown when selectedValue
  /// is null
  final String? defaultValue;

  DropDownWidget(
      {Key? key,
       this.width,
      this.margin,
      this.padding,
      this.onChange,
      this.height,
      this.backGroundColor,
      this.borderRadius,
      this.defaultValue,
      this.hintText,
      this.border,
      this.children,
      this.selectedValue,
      this.style,
      this.label,
      this.dropDownAlignment,
      this.isMandate = false,
    
      this.iconSize,
      this.endWidget, this.dropdownColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("dropdown-builted: ${this.selectedValue}");
    //function to get the value of dropdownmenu item
    String getValue(DropdownMenuItem<String> val) {
      return val.value!.toLowerCase();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label == null
            ? Container()
            : Align(
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  TextSpan(
                    text: '$label',
                    children: <InlineSpan>[
                      TextSpan(
                        text: isMandate ? ' *' : '',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    style: style ?? robotoRegular18,
                  ),
                ),
              ),
        SizedBox(height: label == null ? 0 : 10),
        Align(
          alignment: dropDownAlignment ?? Alignment.center,
          child: Container(
            width: width ?? double.infinity,
            height: height ?? 43,
            alignment: Alignment.center,
            margin: margin ?? const EdgeInsets.symmetric(vertical: 10),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
                color: backGroundColor ?? Colors.white,
                border: border ?? Border.all(color: Colors.grey),
                borderRadius: borderRadius ?? BorderRadius.circular(5)),
            // dropdown below..
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                child: DropdownButton<String>(
                    dropdownColor:  dropdownColor,
                    icon: endWidget ??
                        RotatedBox(
                          quarterTurns: 1,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: iconSize ?? 18,
                            color: Colors.white,
                          ),
                          // onPressed: () {},
                          // ),
                        ),
                    iconSize: 18,
                    hint: Text(
                      hintText ?? 'Select',
                      style: style ??
                          const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto',
                            color: Colors.black,
                          ),
                    ),
                    isExpanded: true,
                    underline: const SizedBox(),
                    value: selectedValue,
                    onChanged: (String? newValue) => onChange!(newValue!),
                    items:
                        children!.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: style,
                        ),
                      );
                    }).toList()
                          ..sort((a, b) => getValue(a).compareTo(getValue(b)))),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
