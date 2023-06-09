// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ordinals_pres/src/net_interface/interface.dart';
import 'package:ordinals_pres/src/provider/picture_provider.dart';
import 'package:ordinals_pres/src/support/app_sizes.dart';
import 'package:ordinals_pres/src/support/breakpoints.dart';
import 'package:ordinals_pres/src/widgets/alert_dialogs.dart';
import 'package:ordinals_pres/src/widgets/flat_custom_btn.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _controller = TextEditingController();
  String imageURL = "";
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        ref.read(pictureProvider.notifier).getPicture(null);
      } else {
        ref.read(pictureProvider.notifier).getPicture(_controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, cons) {
        final size = cons.biggest;
        final isDesktop = size.width > Breakpoint.tablet;
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: isDesktop ? _buildDesktop(size) : _buildMobile(size),
        );
      },
    );
  }

  Widget _buildDesktop(Size size) {
    final pict = ref.watch(pictureProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFEBEAF8),
              Color(0xFFF5EEF1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            width: size.width * 0.95,
            height: size.height * 0.85,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  gapH32,
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Safe Ordinals Checker",
                      style: TextStyle(fontSize: 24, color: Colors.black54),
                    ),
                  ),
                  gapH32,
                  SizedBox(
                    height: size.height * .04,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          decoration: const BoxDecoration(
                              color: Colors.white38,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              )),
                          child: const Center(
                            child: Text(
                              "ID ORD",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                          ),
                        ),
                        Container(
                          height: 35,
                          width: 1,
                          color: Colors.transparent,
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.5))),
                            child: Center(
                              child: AutoSizeTextField(
                                controller: _controller,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.blueGrey),
                                maxLines: 1,
                                minFontSize: 8.0,
                                stepGranularity: 2.0,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  fillColor: Colors.transparent,
                                  filled: true,
                                  hintText: 'Enter a search term',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  gapH32,
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 6 / 5,
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: pict.when(
                              data: (data) {
                                if (data.isEmpty || data["status"] == "empty") {
                                  return const Center(
                                    child: Text(
                                        "Please enter ordinal ID to box above"),
                                  );
                                }
                                final bool nsfw = data["nsfw"];
                                final String status = data["status"];
                                final String? message = data["message"];
                                if (status.toLowerCase() == "fail") {
                                  var mess = "";
                                  if (message == "400") {
                                    mess = "Invalid Ordinal ID";
                                  }
                                  return Center(
                                    child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(child: Text(mess))),
                                  );
                                }
                                if (nsfw) {
                                  return Center(
                                    child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Center(
                                            child:
                                                Text("This ordinal is NSFW"))),
                                  );
                                } else if ((data["image"] as Uint8List?) !=
                                    null) {
                                  return Center(
                                    child: AspectRatio(
                                      aspectRatio: 6 / 5,
                                      child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.lightGreen
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                              child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Image.memory(
                                                  data["image"] as Uint8List),
                                              Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      18.0),
                                                  child: (data["exists"] as bool) == false ?  FlatCustomButton(
                                                    onTap: () async {
                                                     var asdf =  await _saveToGallery(
                                                          data["image"]
                                                              as Uint8List,
                                                          _controller.text);
                                                      _controller.text = "";
                                                     if (asdf) {
                                                       var snackBar = const SnackBar(content: Text('Saved to gallery'), backgroundColor: Colors.lightGreen,);
                                                       if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                     }else{
                                                       var snackBar = const SnackBar(content: Text('Failed to save, ordinal already in the gallery'), backgroundColor: Colors.red,);
                                                       if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                     }
                                                    },
                                                    borderColor: Colors.white38,
                                                    radius: 8,
                                                    width: 60,
                                                    height: 60,
                                                    color: Colors.lightGreen
                                                        .withOpacity(0.5),
                                                    splashColor: Colors
                                                        .lightGreen
                                                        .withOpacity(0.8),
                                                    child: Center(
                                                      child: const Icon(
                                                        Icons.add,
                                                        color: Colors.black54,
                                                        size: 48,
                                                      ),
                                                    ),
                                                  ) : Container(
                                                    width: 120,
                                                    height: 60,
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: Colors.pink,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: const Center(child: AutoSizeText("Already in gallery",
                                                        maxLines: 1,
                                                        minFontSize: 8.0,
                                                        style: TextStyle(color: Colors.white70)),),
                                                  )
                                                ),
                                              )
                                            ],
                                          ))),
                                    ),
                                  );
                                }
                                return Center(
                                  child: Container(
                                      width: size.width * .5,
                                      height: size.height * .6,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                          child: Text("Invalid Ordinal ID"))),
                                );
                              },
                              error: (error, s) => const Center(
                                  child: Text("Invalid Ordinal ID")),
                              loading: () => Center(
                                    child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1.0,
                                          color:
                                              Colors.blueGrey.withOpacity(0.5),
                                        )),
                                  ))),
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }

  Widget _buildMobile(Size size) {
    final pict = ref.watch(pictureProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFEBEAF8),
              Color(0xFFF5EEF1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: SizedBox(
          width: size.width * 0.95,
          height: size.height * 0.85,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                gapH32,
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Safe Ordinals Checker",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),
                gapH32,
                SizedBox(
                  height: size.height * .05,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        decoration: const BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            )),
                        child: const Center(
                          child: Text(
                            "ID ORD",
                            style: TextStyle(
                                fontSize: 12, color: Colors.black54),
                          ),
                        ),
                      ),
                      Container(
                        height: 35,
                        width: 1,
                        color: Colors.transparent,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.5))),
                          child: Center(
                            child: AutoSizeTextField(
                              controller: _controller,
                              style: const TextStyle(
                                  fontSize: 24, color: Colors.blueGrey),
                              maxLines: 1,
                              minFontSize: 8.0,
                              stepGranularity: 2.0,
                              decoration: const InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                fillColor: Colors.transparent,
                                filled: true,
                                hintText: 'Enter a search term',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                gapH32,
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 6 / 5,
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: pict.when(
                            data: (data) {
                              if (data.isEmpty || data["status"] == "empty") {
                                return const Center(
                                  child: Text(
                                      "Please enter ordinal ID to box above"),
                                );
                              }
                              final bool nsfw = data["nsfw"];
                              final String status = data["status"];
                              final String? message = data["message"];
                              if (status.toLowerCase() == "fail") {
                                var mess = "";
                                if (message == "400") {
                                  mess = "Invalid Ordinal ID";
                                }
                                return Center(
                                  child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      child: Center(child: Text(mess))),
                                );
                              }
                              if (nsfw) {
                                return Center(
                                  child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                          child:
                                              Text("This ordinal is NSFW"))),
                                );
                              } else if ((data["image"] as Uint8List?) !=
                                  null) {
                                return Center(
                                  child: AspectRatio(
                                    aspectRatio: 6 / 5,
                                    child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.lightGreen
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                            child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Image.memory(
                                                data["image"] as Uint8List),
                                            Align(
                                              alignment:
                                              Alignment.bottomCenter,
                                              child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      18.0),
                                                  child: (data["exists"] as bool) == false ?  FlatCustomButton(
                                                    onTap: () async {
                                                      var asdf =  await _saveToGallery(
                                                          data["image"]
                                                          as Uint8List,
                                                          _controller.text);
                                                      _controller.text = "";
                                                      if (asdf) {
                                                        var snackBar = const SnackBar(content: Text('Saved to gallery'), backgroundColor: Colors.lightGreen,);
                                                        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      }else{
                                                        var snackBar = const SnackBar(content: Text('Failed to save, ordinal already in the gallery'), backgroundColor: Colors.red,);
                                                        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      }
                                                    },
                                                    borderColor: Colors.white38,
                                                    radius: 8,
                                                    width: 60,
                                                    height: 60,
                                                    color: Colors.lightGreen
                                                        .withOpacity(0.5),
                                                    splashColor: Colors
                                                        .lightGreen
                                                        .withOpacity(0.8),
                                                    child: Center(
                                                      child: const Icon(
                                                        Icons.add,
                                                        color: Colors.black54,
                                                        size: 48,
                                                      ),
                                                    ),
                                                  ) : Container(
                                                    width: 120,
                                                    height: 60,
                                                    padding: const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: Colors.pink,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: const Center(child: AutoSizeText("Already in gallery",
                                                        maxLines: 1,
                                                        minFontSize: 8.0,
                                                        style: TextStyle(color: Colors.white70)),),
                                                  )
                                              ),
                                            )
                                          ],
                                        ))),
                                  ),
                                );
                              }
                              return Center(
                                child: Container(
                                    width: size.width * .5,
                                    height: size.height * .6,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                        child: Text("Invalid Ordinal ID"))),
                              );
                            },
                            error: (error, s) => const Center(
                                child: Text("Invalid Ordinal ID")),
                            loading: () => Center(
                                  child: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.0,
                                        color:
                                            Colors.blueGrey.withOpacity(0.5),
                                      )),
                                ))),
                  ),
                )
              ]),
        ),
      ),
    );
  }

  Future<bool> _saveToGallery(Uint8List data, String nameFile) async {
    try {
      final value = base64Encode(data);
      await ComInterface().post("/image/save", body: {"base64": value, "name": nameFile});
      return true;
    } catch (e) {
      showAlertDialog(
          context: context,
          title: "Error",
          content: "Error when saving to gallery");
      return false;
    }
  }
}
