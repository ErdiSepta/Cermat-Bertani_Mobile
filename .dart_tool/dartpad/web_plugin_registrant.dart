// Flutter web plugin registrant file.
//
// Generated file. Do not edit.
//

// @dart = 2.13
// ignore_for_file: type=lint

import 'package:google_sign_in_web/google_sign_in_web.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:printing/printing_web.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';
import 'package:smart_auth/smart_auth_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void registerPlugins([final Registrar? pluginRegistrar]) {
  final Registrar registrar = pluginRegistrar ?? webPluginRegistrar;
  GoogleSignInPlugin.registerWith(registrar);
  ImagePickerPlugin.registerWith(registrar);
  PrintingPlugin.registerWith(registrar);
  SharedPreferencesPlugin.registerWith(registrar);
  SmartAuthWeb.registerWith(registrar);
  registrar.registerMessageHandler();
}
