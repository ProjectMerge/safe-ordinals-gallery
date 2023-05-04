import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rckt_launch_app/src/support/app_sizes.dart';
import 'package:rckt_launch_app/src/support/breakpoints.dart';
import 'package:rckt_launch_app/src/widgets/flat_custom_btn.dart';

class GalleryPage extends ConsumerStatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  ConsumerState<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends ConsumerState<GalleryPage> {
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
    return Column(
      children: [
        gapH64,
        Expanded(
          child: SingleChildScrollView(
            child: SizedBox(
              width: size.width * 0.95,
              child: Stack(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 8.0, right: 12.0),
                      height: size.height * 0.43,
                      width: size.width * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          gapW32,
                          Container(
                            padding: const EdgeInsets.all(50.0),
                            height: size.height * 0.365,
                            width: size.width * 0.27,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              "assets/images/flutter_logo.png",
                              fit: BoxFit.none,
                            ),
                          ),
                          gapW48,
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              gapH32,
                              SizedBox(
                                width: size.width * 0.345,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      "Flutter Logo",
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                                    ),
                                    const Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                      size: 24,
                                    )
                                  ],
                                ),
                              ),
                              gapH32,
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 30,
                                    backgroundImage:
                                        NetworkImage("https://launchpadbucket.s3.us-west-1.amazonaws.com/238a195d4c4173ac3d73b2bdab5feb0b..webp"),
                                  ),
                                  gapW16,
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Kuso Miso",
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white, fontSize: 18),
                                      ),
                                      gapH4,
                                      Text(
                                        "@FlutterDeveloper",
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white70, fontSize: 14),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              gapH32,
                              Row(children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Price for Ordinal",
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w200),
                                    ),
                                    gapH16,
                                    Row(
                                      children: [
                                        Image.network("https://seeklogo.com/images/B/binance-smart-chain-bsc-logo-9C34053D61-seeklogo.com.png", height: 30, width: 30),
                                        gapW12,
                                        Text(
                                          "0.54 BSC",
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white, fontSize: 30),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                gapW64,
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Time to end",
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w200),
                                    ),
                                    gapH16,
                                    Row(
                                      children: [
                                        Text(
                                          "02h 01m 12s",
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white, fontSize: 30),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],),
                              gapH48,
                              gapH8,
                              Row(
                                children: [
                                  FlatCustomButton(
                                    height: 50,
                                    width: 200,
                                    color: Colors.white,
                                    splashColor: Colors.limeAccent,
                                    radius: 10,
                                    onTap: () {},
                                    child: Text(
                                      "Buy Now",
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black, fontSize: 18),
                                    ),
                                  ),
                                  gapW64,
                                  FlatCustomButton(
                                    height: 50,
                                    width: 200,
                                    color: Colors.transparent,
                                    splashColor: Colors.white,
                                    borderWidth: 1,
                                    borderColor: Colors.white,
                                    radius: 10,
                                    onTap: () {},
                                    child: Text(
                                      "View collection",
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildMobile(Size size) {
    return Container();
  }
}
