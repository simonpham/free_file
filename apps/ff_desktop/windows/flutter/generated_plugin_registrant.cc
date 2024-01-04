//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <bitsdojo_window_windows/bitsdojo_window_plugin.h>
#include <desktop_lifecycle/desktop_lifecycle_plugin.h>
#include <desktop_multi_window/desktop_multi_window_plugin.h>
#include <flutter_acrylic/flutter_acrylic_plugin.h>
#include <pasteboard/pasteboard_plugin.h>
#include <system_theme/system_theme_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  BitsdojoWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("BitsdojoWindowPlugin"));
  DesktopLifecyclePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopLifecyclePlugin"));
  DesktopMultiWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DesktopMultiWindowPlugin"));
  FlutterAcrylicPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterAcrylicPlugin"));
  PasteboardPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PasteboardPlugin"));
  SystemThemePluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SystemThemePlugin"));
}
