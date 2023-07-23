import 'package:permission_handler/permission_handler.dart';

/// Requests all mandatory permissions. Returns true if at least one permission was not granted
Future<bool> requestPermissions() async{
  final permissions = {Permission.location};
  var denied = false;
  for(final permission in permissions){
    final status = await permission.request();
    if(status == PermissionStatus.denied){
      denied = true;
    }
    else if(status == PermissionStatus.permanentlyDenied){
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
      await openAppSettings();
      final newStatus = await permission.request();
      denied |= newStatus == PermissionStatus.permanentlyDenied || newStatus == PermissionStatus.denied ;
    }
  }
  return denied;
}