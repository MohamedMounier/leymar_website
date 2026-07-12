import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lymar_sample_project/core/theme/app_theme.dart';
import 'package:lymar_sample_project/cubits/localization/localization_cubit.dart';
import 'package:lymar_sample_project/cubits/cart/cart_cubit.dart';
import 'package:lymar_sample_project/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const YlmarApp(),
    ),
  );
}

class YlmarApp extends StatelessWidget {
  const YlmarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 900),
      minTextAdapt: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => LocalizationCubit()),
            BlocProvider(create: (_) => CartCubit()),
          ],
          child: MaterialApp.router(
            title: 'Ylmar',
            theme: AppTheme.theme,
            routerConfig: AppRouter.router,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
