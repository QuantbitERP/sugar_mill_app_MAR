import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sugar_mill_app/router.router.dart';

getHeight(context) => (MediaQuery.of(context).size.height);
getWidth(context) => (MediaQuery.of(context).size.width);

Color lightBlack = Colors.black.withOpacity(0.5);

String name = "Quant Sugar";
const kAadharpdf = "AadharCard";
const kPanpdf = "PanCard";
const kBankpdf = "BankPassbook";
const kConcentpdf = "ConcentLetter";

const apiBaseUrl = "https://erpvppl.erpdata.in";

/// api usrls
String apifetchSeason =
    '$apiBaseUrl/api/resource/Season?filters=[["disabled","=","0"]]';
String apifetchPlant = '$apiBaseUrl/api/resource/Branch';

///farmer List
String apimethodcall =
    '$apiBaseUrl/api/method/sugar_mill.sugar_mill.doctype.farmer_list.farmer_list.vendor_code?docname=Farmer List';
String apiVillageListGet =
    '$apiBaseUrl/api/resource/Village?limit_page_length=999999&fields=["name","circle_office","taluka"]';
String apiBankListGet =
    '$apiBaseUrl/api/resource/Bank Master?fields=["bank_name","branch","ifsc_code"]&limit_page_length=999999';
String apiFarmerListPost = '$apiBaseUrl/api/resource/Farmer List';
String apiUploadFilePost = '$apiBaseUrl/api/method/upload_file';
String apiSupplierList =
    '$apiBaseUrl/api/resource/Supplier?limit_page_length=999999999&fields=["name","supplier_name"]&filters=[["supplier_group","in",["Nursery","Drip"]]]';
String apiFarmerAllListGet =
    '$apiBaseUrl/api/resource/Farmer List?fields=["supplier_name","village","name","workflow_state","circle_office","existing_supplier_code"]&limit_page_length=30&order_by=workflow_state desc,creation desc&filters=[["workflow_state","in",["Pending","Pending For Agriculture Officer","New","Approved"]]]';
String apitFilterOnFarmerListGet =
    "$apiBaseUrl/api/resource/Farmer List?order_by=creation desc&limit_page_length=20&fields=[\"supplier_name\",\"village\",\"name\",\"circle_office\",\"existing_supplier_code\"]&filters=[[\"village\",  \"like\", \"bed%\" ],[\"supplier_name\",  \"like\", \"abhi%\" ]]";
String apiLoginGet = '$apiBaseUrl/api/method/login';

///Cane Registration
String apifetchCaneList =
    '$apiBaseUrl/api/resource/Cane Master?order_by=plot_no desc&fields=["plot_no","plantation_status","route_name","crop_variety","name","grower_code","grower_name","plantattion_ratooning_date","survey_number"]';
String apiFarmerListGetwithfilter =
    '$apiBaseUrl/api/resource/Farmer List?fields=["supplier_name","existing_supplier_code","name"]&filters=[["workflow_state","=","approved"],["is_farmer","=",1]]&limit_page_length=999999';
String apiCaneRegistration = '$apiBaseUrl/api/resource/Cane Master';
String apiEmployeeCheckin = '$apiBaseUrl/api/resource/Employee Checkin';
String apifetchroute =
    '$apiBaseUrl/api/resource/Route?fields=["route","distance_km","name"]&limit_page_length=99999';
String apifetchcanevariety =
    '$apiBaseUrl/api/resource/Cane Variety?limit_page_length=50';
String apifetchplantationsystem = '$apiBaseUrl/api/resource/Plantation System';
String apifetchseedmaterial = '$apiBaseUrl/api/resource/Seed Material Used';
String apifetchirrigationmethod = '$apiBaseUrl/api/resource/Irrigation Method';
String apifetchcrptype = '$apiBaseUrl/api/resource/Crop Type';
String apifetchirrigationsource = '$apiBaseUrl/api/resource/Irrigation Source';
String apifetchsoiltype = '$apiBaseUrl/api/resource/Soil Type';

///Agri
String apifetchcanelistwithfilter =
    '$apiBaseUrl/api/resource/Cane Master?fields=["vendor_code","grower_name","area","crop_type","crop_variety","plantattion_ratooning_date","area_acrs","plant_name","name"]&filters=[["season","=",""]]&limit_page_length=99999';
String apiListagri = '$apiBaseUrl/api/resource/Agriculture Development';
String apigetagrilist =
    '$apiBaseUrl/api/resource/Agriculture Development?order_by=creation desc&fields=["crop_type","plot_no","crop_variety","date","area","village","name","survey_number"]';

///Crop Sampling
String apiPostCropSampling = "$apiBaseUrl/api/resource/Crop Sampling";
String apiListSampling =
    '$apiBaseUrl/api/resource/Crop Sampling?fields=["id","plot_no","plantattion_ratooning_date","average_brix","grower_name","route","form_number","crop_variety","name","area"]&filters=[["plantation_status","=","To Sampling"]]&order_by=modified desc';
String apiCompletedListSampling =
    '$apiBaseUrl/api/resource/Crop Sampling?fields=["id","plot_no","plantattion_ratooning_date","average_brix","grower_name","route","form_number","crop_variety","name","area"]&filters=[["plantation_status","=","To Harvesting"]]&order_by=modified desc';

///TripSheet
String apifetchplotnumber =
    '$apiBaseUrl/api/resource/Crop Harvesting?fields=["id","grower_code","grower_name","area","crop_variety","plantattion_ratooning_date","survey_number","area_acrs","name","route","route_km"]&filters=[["season","=","2022-2023"]]';
String apifetchtransportinfo =
    '$apiBaseUrl/api/resource/H and T Contract?fields=["name","old_no","transporter_name","transporter_code","harvester_code","harvester_name","vehicle_type","vehicle_no","trolly_1","trolly_2","gang_type"]&limit_page_length=9999999';
String apifetchFarList =
    '$apiBaseUrl/api/resource/Farmer List?fields=["name","supplier_name","existing_supplier_code"]&filters=[["workflow_state","=","approved"]]&limit_page_length=9999999';
String apifetchtripsheetData = '$apiBaseUrl/api/resource/Trip Sheet';
String apifetchtripsheetsearch =
    '$apiBaseUrl/api/resource/Trip Sheet?order_by=creation desc&fields=["name","farmer_name","field_village","transporter_name","circle_office","season","slip_no"]&limit_page_length=99';

///functions
// Future<Map<String, String>> getTocken() async {
//   final Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
//   final SharedPreferences prefs = await prefs0;
//   String cookies = prefs.getString("Cookie") ?? "";
//   String fresponse = cookies;
//   String? sid = getValueFromResponse(fresponse, 'sid');
//   String? systemUser = getValueFromResponse(fresponse, 'system_user');
//   String? fullName = getValueFromResponse(fresponse, 'full_name');
//   String? userId = getValueFromResponse(fresponse, 'user_id');
//   String? userImage = getValueFromResponse(fresponse, 'user_image');
//
//   String formattedString = 'full_name=${Uri.decodeComponent(fullName)}; '
//       'sid=$sid; '
//       'system_user=$systemUser; '
//       'user_id=$userId; '
//       'user_image=$userImage';
//   return {'Cookie': formattedString};
// }

Future<String> getToken() async {
  final Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
  final SharedPreferences prefs = await prefs0;
  String? apiSecret = prefs.getString("api_secret") ?? "";
  String? apiKey = prefs.getString("api_key") ?? "";
  String formattedString = 'token $apiKey:$apiSecret';
  return formattedString;
}

String getValueFromResponse(String response, String key) {
  RegExp regex = RegExp('$key=([^;,]+)');
  Match? match = regex.firstMatch(response);
  return match != null ? match.group(1) ?? '' : '';
}

void logout(BuildContext context) async {
  final Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
  final SharedPreferences prefs = await prefs0;
  prefs.remove("api_key");
  prefs.remove("api_secret");
if (context.mounted) {
    Navigator.popAndPushNamed(context, Routes.loginViewScreen);
  }
}

String generateUniqueFileName(File file) {
  // Get the original file name and extension
  String originalFileName = file.path.split('/').last;
  String extension = originalFileName.split('.').last;

  // Generate a unique identifier (You can use any method you prefer)
  String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

  // Combine the unique identifier with the original extension
  String uniqueFileName = '$uniqueId.$extension';

  return uniqueFileName;
}

bool isImage(File file) {
  List<String> imageExtensions = ['.png', '.jpg', '.jpeg', '.gif', '.bmp'];
  String extension = file.path.split('.').last.toLowerCase();
  return imageExtensions.contains(extension);
}

bool isPDF(File file) {
  String extension = file.path.split('.').last.toLowerCase();
  return extension == '.pdf';
}

Future<File?> compressFile(File file) async {
  // Get the file path.
  final filePath = file.absolute.path;

  // Get the file extension.
  final fileExtension = filePath.split('.').last;

  // Create a new file name with the extension "_compressed".
  final compressedFileName =
  filePath.replaceAll(fileExtension, '_compressed.jpeg');

  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    compressedFileName,
    quality: 60,
    // rotate: 180,
  );

  return fileFromXFile(result ?? XFile(""));
}

// Convert an XFile object to a File object.
File fileFromXFile(XFile xfile) {
  // Get the file path.
  final filePath = xfile.path;

  // Create a File object.
  final file = File(filePath);

  return file;
}
