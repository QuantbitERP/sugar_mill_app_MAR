import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:sugar_mill_app/constants.dart';
import 'package:sugar_mill_app/models/checkin.dart';
import 'package:sugar_mill_app/models/employee.dart';
import 'package:sugar_mill_app/services/chekin_Services.dart';
import 'package:sugar_mill_app/services/geolocation_service.dart';
import '../../models/dashboard_model.dart';
import '../../services/login_success.dart';
import '../../widgets/updatedialog.dart';

class HomeViewModel extends BaseViewModel {
  Checkin checkindata = Checkin();
  Employee employee = Employee();
  Dashboard dashboard = Dashboard();
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  List<String> season = [""];
  List<Employee> empList = [];
  List<Checkin> checkinList = [];
  String appVersion = "Loading...";
  String? greeting;
  String? imageurl;
  Future<void> getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
        appVersion = "Version ${packageInfo.version} (${packageInfo.buildNumber})";
    } catch (e) {
        appVersion = "Version info unavailable";
    }
  }
  initialise(BuildContext context) async {
    setBusy(true);
    final newVersion = NewVersionPlus(
      androidId: 'com.quantbit.sugarapp',
    );
    getAppVersion();
    Timer(const Duration(milliseconds: 800), () {
      checkNewVersion(newVersion,context);
    });


    season = await LoginServices().fetchSeason();
    if (season.isEmpty) {
      if(context.mounted){
        logout(context);
      }
    }
    handleGreeting();
    handleImage();

    setBusy(false);
  }

  void handleGreeting() {
    final now = DateTime.now();
    final timeOfDay = now.hour;
    if (timeOfDay < 12) {
      greeting = "Good Morning,";
    } else if (timeOfDay < 17) {
      greeting = "Good Afternoon,";
    } else {
      greeting = "Good Evening,";
    }
  }

  void checkNewVersion(NewVersionPlus newVersion, BuildContext context) async {
    final status = await newVersion.getVersionStatus();
    Logger().i(status);
    if(status != null) {
      if(status.canUpdate) {
        if(context.mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return UpdateDialog(
                allowDismissal: true,
                description: status.releaseNotes!,
                version: status.storeVersion,
                appLink: status.appStoreLink,
              );
            },
          );
        }
      }
    }
  }


  void handleImage() {
    final now = DateTime.now();
    final timeOfDay = now.hour;
    if (timeOfDay < 12) {
      imageurl = "assets/images/morning.png";
    } else if (timeOfDay < 17) {
      imageurl = "assets/images/afternoon.png";
    } else {
      imageurl = "assets/images/sunset.png";
    }
  }

  void employeeLog(String logtype, BuildContext context) async {
    setBusy(true);
    GeolocationService geolocationService = GeolocationService();
    try {
      Position? position = await geolocationService.determinePosition();

      if (position == null) {
        Fluttertoast.showToast(msg: 'Failed to get location');
        return setBusy(false);
      }

      Placemark? placemark = await geolocationService.getPlacemarks(position);
      if (placemark == null) {
        Fluttertoast.showToast(msg: 'Failed to get placemark');
        return setBusy(false);
      }

      String formattedAddress =
          await geolocationService.getAddressFromCoordinates(
                  position.latitude, position.longitude) ??
              "";
      checkindata.latitude = position.latitude.toString();
      checkindata.longitude = position.longitude.toString();
      checkindata.deviceId = formattedAddress;
      Logger().i(position.latitude.toString());
      Logger().i(position.longitude.toString());
      Logger().i(formattedAddress);

      bool res = await CheckInServices().addCheckIn(
          logtype,
          position.latitude.toString(),
          position.longitude.toString(),
          formattedAddress);
      if (res) {
        setBusy(false);
        dashboard = await CheckInServices().dashboard() ?? Dashboard();
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '$e');
    } finally {
      setBusy(false);
    }
    setBusy(false);
    notifyListeners();
  }
}
