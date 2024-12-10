import 'dart:convert';
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

import '../constants.dart';
import '../models/list_crop_sampling_model.dart';

class ListCropSamplingServices {



  Future<List<ListSampling>> getListByvillagefarmernameFilter(
      String village, String name,String season,String plotNo) async {
    try {
      var dio = Dio();
      var response = await dio.request(
        '$apiBaseUrl/api/resource/Crop Sampling?fields=["id","plot_no","plantattion_ratooning_date","average_brix","grower_name","route","form_number","crop_variety","name","area"]&filters=[["area","Like","$village%"],["grower_name","Like","%$name%"],["season","like","$season%"],["plot_no","like","$plotNo%"],["plantation_status","=","To Sampling"]]&order_by=modified desc',
        options: Options(
          method: 'GET',
          headers: {'Authorization': await getToken()},
        ),
      );
      Logger().i(response);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(json.encode(response.data));
        List<ListSampling> caneList = List.from(jsonData['data'])
            .map<ListSampling>((data) => ListSampling.fromJson(data))
            .toList();
        Logger().i(caneList);
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
        textColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFFBA1A1A),
      );
      Logger().e(e.response?.data.toString());
    }

    return [];
  }

  Future<List<ListSampling>> getCompletedListByvillagefarmernameFilter(
      String village, String name,String season,String plotNo) async {
    try {
      var dio = Dio();
      var apiUrl= '$apiBaseUrl/api/resource/Crop Sampling?fields=["id","plot_no","plantattion_ratooning_date","average_brix","grower_name","route","form_number","crop_variety","name","area"]&filters=[["area","Like","$village%"],["grower_name","Like","%$name%"],["season","like","$season%"],["plot_no","like","$plotNo%"],["plantation_status","=","To Harvesting"]]&order_by=modified desc';
      var response = await dio.request(
       apiUrl,
        options: Options(
          method: 'GET',
          headers: {'Authorization': await getToken()},
        ),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(json.encode(response.data));
        List<ListSampling> caneList = List.from(jsonData['data'])
            .map<ListSampling>((data) => ListSampling.fromJson(data))
            .toList();
        Logger().i(apiUrl);
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
        textColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFFBA1A1A),
      );
      Logger().e(e.response?.data.toString());
    }
    return [];
  }
}
