import 'package:database/bloc/bloc/notes_bloc.dart';
import 'package:database/bloc/states/crud_states.dart';
import 'package:database/database/db_controller.dart';
import 'package:database/prefs/shared_pref_controller.dart';
import 'package:database/screens/home.dart';
import 'package:database/screens/launch_Screen.dart';
import 'package:database/screens/login.dart';
import 'package:database/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DbController().initDatabase();
  await SharedPrefController().initPrefrences();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375,812),
      minTextAdapt: true,
      builder:(context, child) {
        return BlocProvider<NotesBloc>(
          create: (context) => NotesBloc(LoadingState()),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  appBarTheme: AppBarTheme(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      centerTitle: true,
                      titleTextStyle: GoogleFonts.cairo(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                      iconTheme: const IconThemeData(
                          color: Colors.black
                      )
                  )
              ),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('ar')
              ],
              locale: Locale(SharedPrefController().getValueFor<String>(
                  Prefkeys.language.name) ?? 'en'),

              initialRoute: '/launch',
              routes: {
                '/launch': (context) => const Launch(),
                '/Login': (context) => const Login(),
                '/register': (context) => const Regiser(),
                '/home': (context) => const Home(),
              },

            ),

        );
      }
      );

    }


    }



