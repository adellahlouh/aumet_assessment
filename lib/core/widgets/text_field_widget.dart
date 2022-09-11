import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final bool enableInteractiveSelection;
  final TextInputType? type;
  final int? maxLength;
  final bool radiusSide;
  final bool? obscureText;
  final bool enableInput;
  final bool isRTL ;
  final bool readOnly;
  final int? maxLines;
  final Widget? icon;
  final EdgeInsets? margin;
  final TextAlign? textAlign;
  final VoidCallback? onActionComplete;

  final FormFieldValidator<String>? validator;

  final VoidCallback? onTap;

  final ValueChanged<String>? onChanged;

  final List<TextInputFormatter>? inputFormatters;

  final double? width;

  final Widget? suffixIcon;

  final double? paddingIcon;

  final double marginHorizontal;

  final BorderRadius? borderRadius;

  const TextFieldWidget(
      {Key? key,
        required this.controller,
        required this.hintText,
        this.enableInteractiveSelection = true,
        this.type,
        this.maxLength,
        this.obscureText,
        this.enableInput = true,
        this.isRTL = false,
        this.maxLines,
        this.icon,
        this.radiusSide = true,
        this.validator,
        this.margin,
        this.readOnly = false,
        this.onTap,
        this.onChanged,
        this.textAlign,
        this.onActionComplete,
        this.inputFormatters,
        this.width,
        this.suffixIcon,
        this.paddingIcon,
        this.marginHorizontal = 15.0,
        this.borderRadius})
      : super(key: key);

  @override
  TextFieldWidgetState createState() => TextFieldWidgetState();
}

class TextFieldWidgetState extends State<TextFieldWidget> {
  String text = "";

  @override
  void initState() {
    super.initState();

    text = widget.controller.text ;
  }

  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection:widget.isRTL ?  TextDirection.rtl:TextDirection.ltr,

      child: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Theme.of(context).textTheme.bodyText2!.color,
        ),
        child: Container(
          width: 500,
          margin: widget.margin ??
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
          child: Material(
            elevation: 8.0,
            borderRadius: widget.radiusSide
                ? widget.borderRadius ?? BorderRadius.circular(8.0)
                : const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0)),
            color: Colors.transparent,
            child: TextFormField(
              controller: widget.controller,
              textDirection:widget.isRTL ?  TextDirection.rtl : TextDirection.ltr ,

              style:
              TextStyle(color: Theme.of(context).textTheme.bodyText2!.color),
              enabled: widget.enableInput ,
              keyboardType: widget.type ?? TextInputType.text,
              autofocus: false,
              inputFormatters: widget.inputFormatters,
              maxLines: widget.type == TextInputType.multiline
                  ? null
                  : widget.maxLines ?? 1,
              textAlign: widget.textAlign ?? TextAlign.start,
              validator: widget.validator,
              readOnly: widget.readOnly ,
              onChanged: (text) {
                setState(() {
                  this.text = text;
                });

                widget.onChanged?.call(text);
              },
              maxLength: widget.maxLength,
              obscureText: widget.obscureText ?? false,
              onTap: widget.onTap,

              cursorWidth: 1,
              onEditingComplete: widget.onActionComplete ??
                      () => FocusScope.of(context).nextFocus(),
              decoration: InputDecoration(
                hintTextDirection: widget.isRTL ? TextDirection.rtl : TextDirection.ltr,
                hintText: widget.hintText,
                  counterText:'',
                border: OutlineInputBorder(
                  borderRadius: widget.radiusSide
                      ? widget.borderRadius ?? BorderRadius.circular(8.0)
                      : const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0)),
                  borderSide: const BorderSide(
                    style: BorderStyle.none,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: widget.radiusSide
                      ? widget.borderRadius ?? BorderRadius.circular(8.0)
                      : const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                  ),
                  borderSide: const BorderSide(
                    style: BorderStyle.none,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: widget.radiusSide
                      ? widget.borderRadius ?? BorderRadius.circular(8.0)
                      : const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0)),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: widget.radiusSide
                      ? widget.borderRadius ?? BorderRadius.circular(8.0)
                      : const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0)),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: widget.radiusSide
                      ? widget.borderRadius ?? BorderRadius.circular(8.0)
                      : const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0)),
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: widget.icon,
                suffixIcon: widget.suffixIcon == null
                    ? null
                    : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: widget.suffixIcon,
                ),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
