import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rckt_launch_app/src/support/app_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      restorationScopeId: 'app',
      // routerConfig: goRouter,
      routeInformationParser: goRouter.routeInformationParser,
      routerDelegate: goRouter.routerDelegate,
      routeInformationProvider: goRouter.routeInformationProvider,
      onGenerateTitle: (BuildContext context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],
      theme: ThemeData.from(colorScheme: const ColorScheme.light()).copyWith(
          useMaterial3: true,
          cardTheme: CardTheme(
            elevation: 0,
            color: const Color(0xFF989898).withOpacity(0.2),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
              hintStyle: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white30,
              ),

              labelStyle: const TextStyle(color: Colors.white54),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(style: BorderStyle.solid, color: Colors.white54),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(style: BorderStyle.solid, color: Colors.black87),
              )),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue, accentColor: Colors.black26, backgroundColor: Colors.black),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            backgroundColor: MaterialStateProperty.all(const Color(0xFF5B6E7E)),
            foregroundColor: MaterialStateProperty.all(Colors.blueAccent),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          )),
          textTheme: TextTheme(
            bodyLarge: GoogleFonts.lato(
              fontSize: 32,
              fontWeight: FontWeight.w300,
              color: Colors.black87,
            ),
            bodyMedium: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
            bodySmall: GoogleFonts.lato(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
            titleMedium: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.red),
            displayMedium: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
            displayLarge: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black87),
            displaySmall: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.w200, color: Colors.black87),
          )),

      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      themeMode: ThemeMode.light,

      // Define a function to handle named routes in order to support
      // Flutter web url navigation and deep linking.
      // onGenerateRoute: (RouteSettings routeSettings) {
      //   return MaterialPageRoute<void>(
      //     settings: routeSettings,
      //     builder: (BuildContext context) {
      //       switch (routeSettings.name) {
      //         case SettingsView.routeName:
      //           return SettingsView(controller: settingsController);
      //         case SampleItemDetailsView.routeName:
      //           return const SampleItemDetailsView();
      //         case SampleItemListView.routeName:
      //         default:
      //           return const SampleItemListView();
      //       }
      //     },
      //   );
      // },
    );
  }
}
