import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QRDialog {
  static void openUserQR(context, Map<String, dynamic>? priceData) async {
    var qr = "QR CODE";
    var qrData = qr;
    String currency = "xdn";
    double pixelRatio = 0;
    var onChangeDrop = (String? s) => print(s);
    TextEditingController textController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter sState) {
            pixelRatio = MediaQuery.of(context).devicePixelRatio;
            textController.addListener(() {
              if (textController.text.isNotEmpty) {
                sState(() {
                  qrData = "DigitalNote:$qr?amount=${textController.text}&label=${currency.toUpperCase()}";
                });
              } else {
                sState(() {
                  qrData = qr;
                });
              }

              onChangeDrop = (String? string) {
                if (string != null) {
                  sState(() {
                    currency = string;
                    qrData = "DigitalNote:$qr?amount=${textController.text}&label=${currency.toUpperCase()}";
                  });
                } else {
                  sState(() {
                    qrData = qr;
                  });
                }
              };
            });
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
              child: Dialog(
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(side: BorderSide(color: Color(0xFF9F9FA4)), borderRadius: BorderRadius.all(Radius.circular(15.0))),
                child: Wrap(children: [
                  Container(
                    width: 350.0,
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0, bottom: 2.0),
                            child: SizedBox(
                              width: 350,
                              child: AutoSizeText(
                                "Address",
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 8.0,
                                maxLines: 1,
                                style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 22.0, color: Colors.black87),
                              ),
                            ),
                          ),
                        ),
                        Center(
                            child: Text(
                          '("Tap to copy")',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 14.0, color: Colors.black54),
                        )),
                        const SizedBox(
                          height: 5.0,
                        ),
                        const Divider(
                          color: Colors.grey,
                          height: 4.0,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: qr));
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text("dl_qr_copy"),
                                  duration: Duration(seconds: 3),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.fixed,
                                  elevation: 5.0,
                                ));
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        const Divider(
                          color: Colors.grey,
                          height: 4.0,
                        ),
                        const SizedBox(
                          height: 2.0,
                        ),
                        Text("Request Payment", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 18.0, color: Colors.black87)),
                        const SizedBox(
                          height: 0.0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.center,
                                controller: textController,
                                cursorColor: Colors.black87,
                                autofocus: true,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}')),
                                ],
                                style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black87, fontSize: 22),
                                decoration: InputDecoration(
                                  hintStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(fontStyle: FontStyle.normal, fontSize: 22.0, color: Colors.black54),
                                  hintText: "0.0",
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black87),
                                  ),
// border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                dropdownColor: Colors.white,
                                value: currency,
                                items: priceData!
                                    .map((curr, value) {
                                      return MapEntry(
                                          curr,
                                          DropdownMenuItem<String>(
                                            value: curr.toString(),
                                            child: Text(
                                              curr.toUpperCase(),
                                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black87, fontSize: 22),
                                            ),
                                          ));
                                    })
                                    .values
                                    .toList(),
                                onChanged: onChangeDrop,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ]),
              ),
            );
          });
        });
  }
}
