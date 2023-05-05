import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ordinals_pres/src/provider/picture_provider.dart';
import 'package:ordinals_pres/src/support/app_sizes.dart';
import 'package:ordinals_pres/src/support/breakpoints.dart';
import 'package:ordinals_pres/src/widgets/auto_size_text_field.dart';

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
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  gapH32,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "Safe Ordinals Checker",
                      style: TextStyle(fontSize: 24, color: Colors.black54),
                    ),
                  ),
                  gapH64,
                  Row(
                    children: [
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: const BoxDecoration(
                            color: Colors.white38,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            )),
                        child: const Center(
                          child: Text(
                            "ID ORD",
                            style: TextStyle(fontSize: 14, color: Colors.black54),
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
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              border: Border.all(color: Colors.white.withOpacity(0.5))),
                          child: Center(
                            child: AutoSizeTextField(
                              controller: _controller,
                              style: const TextStyle(fontSize: 24, color: Colors.blueGrey),
                              maxLines: 1,
                              minFontSize: 8.0,
                              decoration: const InputDecoration(
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
                  gapH64,
                  Container(
                      width: size.width *.5,
                      height: size.height *.6,
                      decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: pict.when(
                          data: (data) {
                            if (data.isEmpty || data["status"] == "empty") {
                              return const Center(
                                child: Text("Please enter ordinal ID to box above"),
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
                                    width: size.width *.5,
                                    height: size.height *.6,
                                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(child: Text(mess))),
                              );
                            }
                            if (nsfw) {
                              return Center(
                                child: Container(
                                    width: size.width *.5,
                                    height: size.height *.6,
                                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(child: Text("This ordinal is NSFW"))),
                              );
                            } else if ((data["image"] as Uint8List?) != null) {
                              return Center(
                                child: Container(
                                    width: size.width *.5,
                                    height: size.height *.6,
                                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.lightGreen.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(child: Image.memory(data["image"] as Uint8List))),
                              );
                            }
                            return Center(
                              child: Container(
                                  width: size.width *.5,
                                  height: size.height *.6,
                                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(child: Text("Invalid Ordinal ID"))),
                            );
                          },
                          error: (error, s) => const Center(child: Text("Invalid Ordinal ID")),
                          loading: () => Center(
                                child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.0,
                                      color: Colors.blueGrey.withOpacity(0.5),
                                    )),
                              )))
                ]),
          ),
        ),
      ),
    );
  }

  Widget _buildMobile(Size size) {
    return Container();
  }
}
