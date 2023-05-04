import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ordinals_pres/src/support/app_sizes.dart';
import 'package:ordinals_pres/src/support/breakpoints.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

// ignore: depend_on_referenced_packages
import "package:path/path.dart";
import "package:ordinals_pres/globals.dart" as globals;

import 'package:flutter/foundation.dart';
import 'package:ordinals_pres/src/support/secure_storage.dart';
import 'package:ordinals_pres/src/widgets/flat_custom_btn.dart';

import '../provider/title_provider.dart';

class UploadPage extends ConsumerStatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends ConsumerState<UploadPage> {
  DropzoneViewController? controller;
  Map<String, Uint8List> listFile = {};
  Map<String, dynamic> resulMap = {};
  bool visibleBox = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      ref.read(titleProvider).greeting = "Dashboard";
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
          body: isDesktop ? _buildDesktop(size, context) : _buildMobile(size),
        );
      },
    );
  }

  Widget _buildMobile(Size size) {
    return const Placeholder();
  }

  Widget _buildDesktop(Size size, BuildContext context) {
    return Column(
      children: [
        gapH32,
        Expanded(
          child: Container(
            width: size.width * 1.0,
            color: Colors.white24,
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: size.width * 0.7,
                height: size.height * 0.3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          'Drag and drop your files here',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54
                          ),
                        ),
                        SizedBox(height: 16),
                      ],),
                    SizedBox(
                      width: size.width * 0.7,
                      height: size.height * 0.7,
                      child: DropzoneView(
                        operation: DragOperation.copy,
                        cursor: CursorType.grab,
                        onCreated: (DropzoneViewController ctrl) => controller = ctrl,
                        onLoaded: () => debugPrint('Zone loaded'),
                        onError: (String? ev) => debugPrint('Error: $ev'),
                        onHover: () => setState(() {
                          visibleBox = true;
                        }),
                        onDrop: (dynamic ev) async {
                          final bytes = await controller!.getFileData(ev);
                          final name = await controller!.getFilename(ev);
                          listFile[name] = bytes;
                          setState(() {});
                        },
                        onDropMultiple: (List<dynamic>? ev) {
                          // ignore: avoid_function_literals_in_foreach_calls
                          ev!.forEach((element) async {
                            final bytes = await controller!.getFileData(element);
                            final name = await controller!.getFilename(element);
                            listFile[name.toString()] = bytes;
                          });
                          setState(() {});
                        },
                        onLeave: () => setState(() {
                          visibleBox = false;
                        }),
                      ),
                    ),
                    IgnorePointer(
                      child: Visibility(
                        visible: visibleBox,
                        child: Container(
                          width: size.width * 0.69,
                          height: size.height * 0.28,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.pink.shade100),
                            borderRadius: BorderRadius.circular(8),
                            color: listFile.isEmpty ? Colors.pink.withOpacity(0.05) : Colors.lightGreen.withOpacity(0.1),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        width: size.width * 0.69,
                        height: size.height * 0.28,
                        padding: const EdgeInsets.all(8),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: listFile.length,
                          itemBuilder: (ctx, index) {
                            String key = listFile.keys.elementAt(index);
                            bool? stuff = resulMap[key];
                            Uint8List? value = listFile[key];
                            return Container(
                                width: size.width * 0.69 / 6,
                                height: size.height * 0.18,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(8),
                                  color: stuff == null ? Colors.white : stuff ? Colors.lightGreen.withOpacity(0.8) : Colors.red.withOpacity(0.8),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.memory(value ?? Uint8List(0),),
                                    Positioned(
                                        right: 2,
                                        top: 2,
                                        child: FlatCustomButton(
                                            color: Colors.white12,
                                            radius: 8,
                                            onTap: () {
                                              listFile.remove(key);
                                              setState(() {});
                                            },
                                            child: const Icon(Icons.close, color: Colors.red))),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8),
                                          ),
                                        ),
                                        child: AutoSizeText(
                                          basename(key),
                                          maxLines: 1,
                                          minFontSize: 8,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  ],
                                ));
                          },
                        )),
                  ],
                )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Visibility(
                    visible: listFile.isNotEmpty,
                    child: FlatCustomButton(
                      width: size.width * 0.7,
                      height: 50,
                      radius: 8,
                      color: Colors.lightGreen.shade400,
                      splashColor: Colors.pink.shade300,
                      onTap: () async {
                        await uploadFiles(listFile);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.upload_file, color: Colors.white70, size: 28,),
                          gapW8,
                          Text("upload", style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white70,
                              fontSize: 24,
                              fontWeight: FontWeight.bold)),


                        ],
                      ),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
      ],
    );
  }

  Future<void> uploadFiles(Map<String, Uint8List> files) async {
    try {
      String? daoJWT = await SecureStorage.read(key: globals.TOKEN_DAO);
      print(daoJWT);
      final bearer = "JWT ${daoJWT ?? ""}";
      var uri = Uri.parse("${globals.API_URL}/upload");

      Map<String, String> mHeaders = {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Headers": "*",
            "Access-Control-Allow-Methods": "POST,GET,DELETE,PUT,OPTIONS",
            "Authorization": bearer,
            "Content-Type": "application/json",
            "Auth-Type": "rsa"
          };
      var request = http.MultipartRequest('POST', uri);
      for (var i = 0; i < files.length; i++) {
            String key = listFile.keys.elementAt(i);
            Uint8List? value = listFile[key];
            request.files.add(http.MultipartFile.fromBytes(
              'pictures',
              value!,
              filename: basename(key),
            ));
          }
      request.headers.addAll(mHeaders);
      var response = await request.send();
      if (response.statusCode == 200) {
            print('Uploaded!');
          var result = await response.stream.bytesToString();
          var js = jsonDecode(result);
          resulMap = js['result'];
          if (resulMap != null) {
            print(resulMap);
            setState(() {});
          }
          } else {
            print('Upload failed!');
          }
    } catch (e) {
      print(e);
    }
    // response.stream.transform(utf8.decoder).listen((value) {
    //   print(value);
    // });
  }
}
