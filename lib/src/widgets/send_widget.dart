
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:ordinals_pres/src/support/app_sizes.dart';
import 'package:ordinals_pres/src/widgets/auto_size_text_field.dart';
import 'package:ordinals_pres/src/widgets/flat_custom_btn.dart';

class SendWidget extends StatefulWidget {
  final double? balance;
  final void Function(String address, double amount) send;
  final String? address;

  const SendWidget({Key? key, this.balance,  required this.send,  this.address}) : super(key: key);

  @override
  State<SendWidget> createState() => _SendWidgetState();
}

class _SendWidgetState extends State<SendWidget> {
  final GlobalKey _textFieldAmountKey = GlobalKey();
  final TextEditingController _controllerAmount = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(right:18.0),
            child: ClipOval(
              child: FlatCustomButton(
                height: 30,
                width: 30,
                color: Colors.redAccent.withOpacity(0.9),
                splashColor: Colors.white.withOpacity(0.2),
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Text('X'),
              ),
            ),
          ),
        ),
        gapH12,
        Container(
          height: 140,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            image: const DecorationImage(
              image: AssetImage("assets/images/test_pattern.png"),
              fit: BoxFit.cover,
              opacity: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 4,
                blurRadius: 15,
                offset: const Offset(0, 5), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: AutoSizeTextField(
                              controller: _controllerAddress,
                              maxLines: 1,
                              minFontSize: 10,
                              stepGranularity: 0.1,
                              autofocus: false,
                              style: Theme.of(context).textTheme.headlineSmall,
                              decoration: InputDecoration(
                                counterText: "",
                                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white12, width: 1.0), borderRadius: BorderRadius.circular(15.0)),
                                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white30, width: 1.0), borderRadius: BorderRadius.circular(15.0)),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                contentPadding: const EdgeInsets.only(left: 14.0),
                                labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
                                hintText: "Address",
                                hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16.0, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: AutoSizeTextField(
                              key: _textFieldAmountKey,
                              controller: _controllerAmount,
                              maxLength: 40,
                              maxLines: 1,
                              minFontSize: 10,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}')),
                              ],
                              autofocus: false,
                              style: Theme.of(context).textTheme.headlineSmall,
                              decoration: InputDecoration(
                                counterText: "",
                                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white12, width: 1.0), borderRadius: BorderRadius.circular(15.0)),
                                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white30, width: 1.0), borderRadius: BorderRadius.circular(15.0)),
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                contentPadding: const EdgeInsets.only(left: 14.0),
                                labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
                                hintText: "Amount",
                                hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16.0, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextButton.icon(
                              icon: const Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.white,
                                size: 28,
                              ),
                              label: Text(
                                'Send  ',
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16.0),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith((states) => amountColors(states)),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0), side: const BorderSide(color: Colors.transparent)))),
                              onPressed: ()  {
                                widget.send(_controllerAddress.text, double.parse(_controllerAmount.text));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
            ),
          ),
        ),
      ],
    );
  }

  Color amountColors(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.green;
    }
    return Colors.lightGreen;
  }

  Color qrColors(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.white10;
  }
}
