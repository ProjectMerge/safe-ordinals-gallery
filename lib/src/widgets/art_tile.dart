import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rckt_launch_app/src/support/app_sizes.dart';
import 'package:rckt_launch_app/src/widgets/flat_custom_btn.dart';

class ArtTile extends StatelessWidget {
  const ArtTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      margin: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              gapH16,
              Container(
                  height: height * 0.2,
                  width: width * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black54, width: 0.2),
                  ),
                  child: Image.asset("assets/images/flutter_logo.png")),
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  gapH16,
                  Padding(
                    padding: const EdgeInsets.only(left: 38.0),
                    child: Text("Art #12", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                  gapH8,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: Text("Flutter is Google's UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.",
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                  gapH16,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: Row(
                      children: [
                        Text("Price:",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black87, fontSize: 18)),
                        const Expanded(child: SizedBox()),
                        Row(
                          children: [
                            Text(
                              "0.54 BSC",
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black87, fontSize: 18),
                            ),
                            gapW4,
                            Image.network("https://seeklogo.com/images/B/binance-smart-chain-bsc-logo-9C34053D61-seeklogo.com.png", height: 18, width: 18),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: Row(
                      children: [
                        FlatCustomButton(
                          height: 50,
                          width: 140,
                          color: Colors.blue.shade900,
                          splashColor: Colors.blue.shade300,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          radius: 10,
                          onTap: () {},
                          child: AutoSizeText(
                            "Buy now",
                            maxLines: 1,
                            minFontSize: 8.0,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        gapW64,
                        FlatCustomButton(
                          height: 50,
                          width: 140,
                          color: Colors.transparent,
                          splashColor: Colors.blue.shade200,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          borderWidth: 0.5,
                          borderColor: Colors.black54,
                          radius: 10,
                          onTap: () {},
                          child: AutoSizeText(
                            "View collection",
                            maxLines: 1,
                            minFontSize: 8.0,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black87, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  gapH16,
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
