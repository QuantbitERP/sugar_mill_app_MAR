import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import '../constants.dart';
import '../models/cane_list_model.dart';

class ListCaneService {
  Future<List<CaneListModel>> getAllCaneList() async {
    try {
      
      var dio = Dio();
      var response = await dio.request(
        apifetchCaneList,
        options: Options(
          method: 'GET',
          headers: {'Authorization': await getToken()},
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(json.encode(response.data));
        List<CaneListModel> caneList = List.from(jsonData['data'])
            .map<CaneListModel>((data) => CaneListModel.fromJson(data))
            .toList();
        return caneList;
      } else {
        Logger().e(response.statusMessage);
        return [];
      }
    } on DioException catch (e) {
      Fluttertoast.showToast(
        gravity: ToastGravity.BOTTOM,
        msg:
            'Error: ${e.response?.data["exception"].toString().split(":").elementAt(1).trim()}',
        textColor: Color(0xFFFFFFFF),
        backgroundColor: Color(0xFFBA1A1A),
      );
      Logger().e(e.response?.data.toString());
    }
    return [];
  }

  Future<List<CaneListModel>> getCaneListByNameFilter(
      String season, String name, String village,String plotNo) async {
    try {
      
      var dio = Dio();
      String url =
          '$apiBaseUrl/api/resource/Cane Master?fields=["plantation_status","route_name","crop_variety","name","grower_code","grower_name","plantattion_ratooning_date","survey_number","plot_no"]&filters=[["season","like","$season%"],["plot_no","like","$plotNo%"],["grower_name","like","%$name%"],["route_name","like","$village%"]]&order_by=creation desc';
      Logger().i(url);
      var response = await dio.request(
        url,
        options: Options(
          method: 'GET',
          headers: {'Authorization': await getToken()},
        ),
      );
      Logger().i(response.realUri);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(json.encode(response.data));
        List<CaneListModel> farmersList = List.from(jsonData['data'])
            .map<CaneListModel>((data) => CaneListModel.fromJson(data))
            .toList();
        Logger().i(jsonData);
        return farmersList;
      } else {
        Logger().e(response.statusMessage);
        return [];
      }
    } on DioException catch (e) {
      Fluttertoast.showToast(
        gravity: ToastGravity.BOTTOM,
        msg:
            'Error: ${e.response?.data["exception"].toString().split(":").elementAt(1).trim()}',
        textColor: Color(0xFFFFFFFF),
        backgroundColor: Color(0xFFBA1A1A),
      );
      Logger().e(e.response?.data.toString());
    }

    return [];
  }
}
