import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:sugar_mill_app/models/CaneRoute.dart';
import 'package:sugar_mill_app/models/trip_crop_harvesting_model.dart';
import 'package:sugar_mill_app/models/tripsheet.dart';
import 'package:sugar_mill_app/views/tripsheet_screen/add_tripsheet_list/add_tripsheet_list_model.dart';
import '../../../constants.dart';
import '../../../models/cartlist.dart';
import '../../../models/tripsheet_master.dart';
import '../../../router.router.dart';
import '../../../services/add_tripsheet_service.dart';

class AddTripSheetModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();

  List<String> season = [""];
  List<String> plantList = [""];
  List<CropHarvestingModel> plotList = [];
  TextEditingController plantingDateController = TextEditingController();
  TextEditingController slipnoController = TextEditingController();
  TextEditingController deductionController = TextEditingController();
  TextEditingController watershareController = TextEditingController();
  TextEditingController engineNumberController = TextEditingController();
  TextEditingController tolly1Controller = TextEditingController();
  TextEditingController tolly2Controller = TextEditingController();

  List<String> deductionType = [
    "",
    "Burn Cane",
    "Unmatured Cane",
  ];

  List<String> ropeType = [
    "All",
    "trailor 1 st",
    "trailor  2 nd",
    "1 st & 2 nd trailor  upper rope",
    "1 st and 2 nd Bottom rope",
    "1st trailor all & 2nd  trailor  Upper Rope",
    "1st trailor all & 2nd  trailor  Bottom Rope",
    "1st trailor  upper rope",
    "1st trailor  Bottom rope",
    "2nd trailor all & 1st  trailor  Upper Rope",
    "2nd trailor  Bottom rope",
    "TL Middle Rope",
    "TL Middle Rope 1",
    "TL Bottom Rope",
    "TL Bottom & Middle Rope",
    "TL Top & Middle Rope",
    "2nd trailor all & 1st trailor bottom rope",
    "2nd trailor upper rope",
    "TL Middle Rope 2",
    "TL Upper Rope",
  ];
  CartInfo cartinfo = CartInfo();
  List<WaterSupplierList> waterSupplier = [];
  List<CaneRoute> routeList = [];
  List<String> gangTypeList=[];
  List<TransportInfo> transportList = [];
  List<VehicleType> vehicleTypeList = [];
  String? plotNo;
  String? farmerCode;
  String? farmerName;
  String? village;
  String? caneVariety;
  String? surveyNo;
  String? routename;
  double? area;
  String? selectedfarcode;
  String? seletedvendor;
  DateTime? selectedDate;
  double? dist;
  String? transName;
  String? vehicleType;
  String? gangType;
  String? harCode;
  String? harName;
  String? eNo;
  String? trl_1;
  String? tri_2;
  String? gang;
  String? watersupplierName;
  bool isEdit = false;
  bool applyFlatRate = false;
  TripSheet tripSheetData = TripSheet();
  String? selectedCaneRoute;
  bool isSelectTransporter = false;
  TripSheetMasters masters = TripSheetMasters();
  FocusNode tolly2FocusNode = FocusNode();

  void onSavePressed(BuildContext context) async {
    setBusy(true);
    bool res = false;
    Logger().i(tripSheetData.toJson());
    if (formKey.currentState!.validate()) {
      if (isEdit == true) {
        res = await AddTripSheetServices().updateTrip(tripSheetData);
        if (res) {
          if (context.mounted) {
            setBusy(false);
            setBusy(false);
            Navigator.pop(context, const MaterialRoute(page: ListTripsheet));
          }
        }
      } else {
        res = await AddTripSheetServices().addTripSheet(tripSheetData, context);
        if (res) {
          if (context.mounted) {
            setBusy(false);
            setBusy(false);
          }
        }
      }
    }
    setBusy(false);
  }

  Future<void> initialize(BuildContext context, String tripId) async {
    setBusy(true);
    plotList = await AddTripSheetServices().fetchPlot("");
    masters = await AddTripSheetServices().getMasters() ?? TripSheetMasters();
    Logger().i(masters.toJson());
    season = masters.season ?? [];
    plantList = masters.plant ?? [];
    routeList = masters.caneRoute ?? [];
    transportList = masters.transportInfo ?? [];
    waterSupplier = masters.waterSupplierList ?? [];
    vehicleTypeList = masters.vehicleType ?? [];
    ropeType=masters.rope ?? [];
    tripSheetData.branch = "Bedkihal";
    int currentYear = DateTime.now().year;
    // Filter the list to get the latest season
    String latestSeason = season.firstWhere(
      (season) => season.startsWith("$currentYear-"),
      orElse: () => season
          .last, // If no season matches the current year, take the last one
    );
    tripSheetData.season = latestSeason;
   transportList= transportList.where((transporter) => transporter.season == latestSeason).toList();
   Logger().i(transportList);
    if (season.isEmpty) {
      if(context.mounted) {
        logout(context);
      }
    }

    try {
      // Fetch data from services
      final results = await Future.wait([
        AddTripSheetServices().fetchPlot(""),
        AddTripSheetServices().getMasters(),
      ]);

      // Assign results
      plotList = results[0] as List<CropHarvestingModel>;
      masters = results[1] as TripSheetMasters? ?? TripSheetMasters();
      // Initialize master lists
      season = masters.season ?? [];
      plantList = masters.plant ?? [];
      routeList = masters.caneRoute ?? [];
      gangTypeList=masters.gangType ?? [];
      transportList = masters.transportInfo ?? [];
      waterSupplier = masters.waterSupplierList ?? [];
      vehicleTypeList = masters.vehicleType ?? [];
      ropeType = masters.rope ?? [];
      tripSheetData.branch = "Bedkihal";
Logger().i(masters.toJson());
      // Get the latest season
      int currentYear = DateTime.now().year;
      tripSheetData.season = season.firstWhere(
            (seasonItem) => seasonItem.startsWith("$currentYear-"),
        orElse: () => season.isNotEmpty ? season.last : "",
      );

      // Filter transporters for the selected season
      transportList = transportList.where((transporter) {
        return transporter.season == tripSheetData.season;
      }).toList();

      // Check for empty lists and show error messages
      _checkEmptyList(
        context,
        list: season,
        message: 'No season data available. Logging out.',
        action: () => logout(context),
      );

      _checkEmptyList(
        context,
        list: waterSupplier,
        message: 'There is no farmer available.',
      );

      _checkEmptyList(
        context,
        list: transportList,
        message: 'There is no transporter available.',
      );

      // Handle trip edit mode
      if (tripId.isNotEmpty) {
        await _initializeEditMode(tripId);
      }
    } catch (e) {
      Logger().e("Initialization failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'An error occurred during initialization.',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setBusy(false);
    }
  }

  Future<void> _initializeEditMode(String tripId) async {
    isEdit = true;
    tripSheetData = await AddTripSheetServices().getTripsheet(tripId) ?? TripSheet();
    cartinfo = await AddTripSheetServices()
        .cartInfo(tripSheetData.cartno.toString()) ??
        CartInfo();

    applyFlatRate = tripSheetData.applyFlatRate == 1;
    slipnoController.text = tripSheetData.slipNo.toString();
    deductionController.text = tripSheetData.deduction?.toStringAsFixed(0) ?? "0";
    watershareController.text = tripSheetData.waterShare.toString();
    engineNumberController.text = tripSheetData.vehicleNumber.toString();
    tolly1Controller.text = tripSheetData.tolly1.toString();
    tolly2Controller.text = tripSheetData.tolly2.toString();

    plantingDateController.text = tripSheetData.plantationDate != null
        ? DateFormat('dd-MM-yyyy')
        .format(DateTime.parse(tripSheetData.plantationDate ?? ""))
        : "";

    selectedCaneRoute = routeList
        .firstWhere(
          (route) => route.name == tripSheetData.routeName,
      orElse: () => CaneRoute(),
    )
        .route;

    plotNo = plotList
        .firstWhere(
          (plot) => plot.name == tripSheetData.plotNo,
      orElse: () => CropHarvestingModel(),
    )
        .plotNo;

    selectedfarcode = plotList
        .firstWhere(
          (plot) => plot.growerCode == tripSheetData.farmerCode,
      orElse: () => CropHarvestingModel(),
    )
        .vendorCode;

    watersuppliercode = waterSupplier
        .firstWhere(
          (supplier) => supplier.name == tripSheetData.waterSupplier,
      orElse: () => WaterSupplierList(),
    )
        .existingSupplierCode;

    notifyListeners();
  }

  void _checkEmptyList(BuildContext context,
      {required List<dynamic> list,
        required String message,
        VoidCallback? action}) {
    if (list.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      if (action != null) action();
    }
  }


  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      plantingDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      tripSheetData.plantationDate = plantingDateController.text;
    }
  }

  void showSuccessDialog(BuildContext context, String? name) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("slip no $name registered successfully"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, Routes.addTripSheetScreen,
                    arguments: const AddTripSheetScreenArguments(
                        tripId: '')); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void setSelectedSeason(BuildContext context, String? season) async {
    tripSheetData.season = season;
    plotList = await AddTripSheetServices().fetchPlot(season ?? "");
    transportList=transportList.where((transport)=>transport.season==season).toList();
    Logger().i(transportList.length);
    if (plotList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'There is No plot available at season $season from harvesting',
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
          duration: const Duration(seconds: 3), // Adjust the duration as needed
        ),
      );
    }
    notifyListeners();
  }

  void setSelectedPlant(String? plantList) {
    tripSheetData.branch = plantList;
    notifyListeners();
  }

  void setSelectedPlotNo(String? plotNumber) {
    final selectedGrowerData = plotList.firstWhere(
          (growerData) => growerData.plotNo == plotNumber,
      orElse: () => CropHarvestingModel(), // Provide a fallback
    );

    Logger().i(selectedGrowerData.toJson().toString());
    plotNo = selectedGrowerData.plotNo;
    tripSheetData.plotNo = selectedGrowerData.id;
    farmerCode = selectedGrowerData.growerCode;
    farmerName = selectedGrowerData.growerName;
    village = selectedGrowerData.area;
    caneVariety = selectedGrowerData.cropVariety;
    surveyNo = selectedGrowerData.surveyNumber;
    area = selectedGrowerData.areaAcrs;

    plantingDateController.text = selectedGrowerData.plantattionRatooningDate ?? "";
    tripSheetData
      ..plotNo = selectedGrowerData.name
      ..platNoId = selectedGrowerData.id
      ..vendorCode = selectedGrowerData.vendorCode
      ..farmerCode = farmerCode
      ..farmerName = farmerName
      ..plantationDate = plantingDateController.text
      ..fieldVillage = village
      ..caneVariety = caneVariety
      ..surveryNo = surveyNo
      ..areaAcre = area
      ..routeName = selectedGrowerData.route
      ..distance = double.tryParse(selectedGrowerData.routeKm ?? "");

    final selectedRouteData = routeList.firstWhere(
          (route) => route.name == selectedGrowerData.route,
      orElse: () => CaneRoute(),
    );

    selectedCaneRoute = selectedRouteData.route;

    notifyListeners();
    }

  void setSelectedRoute(CaneRoute route) {
    selectedCaneRoute = route.route;
    tripSheetData.routeName = route.name;
    tripSheetData.distance = route.distanceKm;
    notifyListeners();
  }

  void setSelectedTransCode(String? traCode) async {
    tripSheetData.oldTransporterCode = traCode;

    // Safely find the selected grower data using firstWhere with orElse
    final selectedGrowerData = transportList.firstWhere(
          (growerData) => growerData.oldNo.toString() == traCode,
      orElse: () => TransportInfo(),  // If no match, return null
    );

    Logger().i(selectedGrowerData);

    if (selectedGrowerData.oldNo.toString().toLowerCase() != "self") {
      tripSheetData.transporterCode = selectedGrowerData.name;
      transName = selectedGrowerData.transporterName;
      vehicleType = selectedGrowerData.vehicleType;
      tripSheetData.transporter = selectedGrowerData.transporterCode;
      eNo = selectedGrowerData.vehicleNo;
      trl_1 = selectedGrowerData.trolly1;
      tri_2 = selectedGrowerData.trolly2;

      tripSheetData.vehicleNumber = eNo;
      tripSheetData.tolly1 = trl_1;
      tripSheetData.tolly2 = tri_2;
      tripSheetData.transporterName = transName;
      tripSheetData.vehicleType = vehicleType;
      tripSheetData.cartno = null;

      boolFlatRte();
      setSelectedEngine(tripSheetData.vehicleNumber);
      setSelectedTy_1(tripSheetData.tolly1);
      setSelectedTy_2(tripSheetData.tolly2);
    } else {
      tripSheetData.transporterCode = selectedGrowerData.name;
      tripSheetData.oldTransporterCode = selectedGrowerData.oldNo;
      tripSheetData.transporter = tripSheetData.farmerCode;
      tripSheetData.transporterName = tripSheetData.farmerName;

      setSelectedEngine(null);
      setSelectedTy_1(null);
      setSelectedTy_2(null);
      tripSheetData.vehicleType = null;
    }


    notifyListeners();
  }


  String? watersuppliercode;

  void setSelectedWaterSupplier(WaterSupplierList waterSupp) {
    watersuppliercode = waterSupp.existingSupplierCode;
    tripSheetData.waterSupplier = waterSupp.name;
    notifyListeners();
    tripSheetData.waterSupplierName = waterSupp.supplierName;
    notifyListeners();
  }

  void setSelectedWaterSuppName(String? wsName) {
    watersupplierName = wsName;
    tripSheetData.waterSupplierName = watersupplierName;
    notifyListeners();
  }

  void setSelectedWaterSupShare(String? wsShare) {
    watershareController.value = watershareController.value.copyWith(
      text: wsShare ?? '',
      selection: TextSelection.collapsed(offset: (wsShare ?? '').length),
    );
    tripSheetData.waterShare = double.tryParse(wsShare ?? "");
    Logger().i(tripSheetData.waterShare);
    notifyListeners();
  }

  void setSelectedEngine(String? eng) {
    eNo = eng;
    engineNumberController.text=eng ?? "";
    tripSheetData.vehicleNumber = eNo;
    notifyListeners();
  }


  void setSelectedTy_1(String? tol_1) {
    trl_1 = tol_1;
    tolly1Controller.text=trl_1 ?? "";
    tripSheetData.tolly1 = trl_1;
    notifyListeners();
  }

  void setSelectedTy_2(String? tol_2) {
    tri_2 = tol_2;
    tolly2Controller.text=tri_2 ?? "";
    tripSheetData.tolly2 = tri_2;
    notifyListeners();
  }

  void setSelectedHarCode(String? hCode) {
    tripSheetData.harvesterCodeOld = hCode;

    final selectedGrowerData = transportList.firstWhere(
          (growerData) => growerData.oldNo.toString() == hCode,
      orElse: () => TransportInfo(),
    );

    Logger().i(selectedGrowerData.toJson());

    if (selectedGrowerData.oldNo.toString().toLowerCase() != "self") {
      // Set fields when not "SELF"
      tripSheetData.harvestingCodeHt = selectedGrowerData.name;
      harCode = selectedGrowerData.harvesterCode;
      tripSheetData.harvesterCodeH = harCode;
      harName = selectedGrowerData.harvesterName;
      tripSheetData.harvesterNameH = harName;
    } else {
      // Set fields when "SELF"
      tripSheetData.harvesterCodeOld = selectedGrowerData.oldNo;
      tripSheetData.harvesterCode = selectedGrowerData.name;
      tripSheetData.harvestingCodeHt = selectedGrowerData.name;
      tripSheetData.harvesterCode = tripSheetData.farmerCode;
      tripSheetData.harvesterCodeH = tripSheetData.farmerCode;
      tripSheetData.harvesterName = tripSheetData.farmerName;
      tripSheetData.harvesterNameH = tripSheetData.farmerName;
    }

    // Update gangType regardless of "SELF" or not
    gangType = selectedGrowerData.gangType;
    tripSheetData.gangType = gangType;

    Logger().i(tripSheetData.toJson());

    notifyListeners();
  }


  void setSelectedHarName(String? hName) {
    harName = hName;
    tripSheetData.harvesterNameH = harName;
    notifyListeners();
  }

  void setSelectedTransporterName(String? traName) {
    transName = traName;
    tripSheetData.transporterName = transName;
    notifyListeners();
  }

  void setSelectedVType(String? vType) {
    vehicleType = vType;
    tripSheetData.vehicleType = vehicleType;
    notifyListeners();
  }
  void setSelectedGType(String? vType) {
    gangType = vType;
    tripSheetData.gangType = gangType;
    notifyListeners();
  }
  void setSelectedDistance(String? distance) {
    tripSheetData.distance = double.tryParse(distance ?? "");
    notifyListeners();
  }

  void setSelectFarmerCode(String? farCode) {
    farmerCode = farCode;
    tripSheetData.farmerCode = farmerCode;
    notifyListeners();
  }

  void setSelectFarmerName(String? farName) {
    farmerName = farName;
    tripSheetData.farmerName = farmerName;
    notifyListeners();
  }

  void setSelectVillage(String? village) {
    village = village;
    tripSheetData.fieldVillage = village;
    notifyListeners();
  }

  void setSelectVariety(String? variety) {
    caneVariety = variety;
    tripSheetData.caneVariety = caneVariety;
    notifyListeners();
  }

  void setSelectPlantationDate(String? plantationDate) {
    tripSheetData.caneVariety = plantationDate;
    notifyListeners();
  }

  void setSelectSurvey(String? survey) {
    surveyNo = survey;
    tripSheetData.surveryNo = surveyNo;
    notifyListeners();
  }

  void setSelectArea(String? areaAcr) {
    area = double.tryParse(areaAcr ?? "");
    tripSheetData.areaAcre = area;
    notifyListeners();
  }

  void setSelectSlipNo(String? slipNo) {
    slipnoController.value = slipnoController.value.copyWith(
      text: slipNo ?? '',
      selection: TextSelection.collapsed(offset: (slipNo ?? '').length),
    );
    tripSheetData.slipNo = int.tryParse(slipNo ?? "");
    notifyListeners();
  }

  void setSelectedDeduction(String? deduction) {
    tripSheetData.burnCane = deduction;
    notifyListeners();
  }

  void boolFlatRte() {
    // Safely find the selected route using firstWhere with orElse
    final selectedRoute = routeList.firstWhere(
          (route) => route.name == tripSheetData.routeName,
      orElse: () => CaneRoute(), // If no match, return null
    );

    // Safely find the selected vehicle type using firstWhere with orElse
    final selectedVehicleType = vehicleTypeList.firstWhere(
          (vehicleType) => vehicleType.name == tripSheetData.vehicleType,
      orElse: () => VehicleType(), // If no match, return null
    );

    // Check if both selectedRoute and selectedVehicleType are found
    if (selectedRoute.applyFlatRate == 1 && selectedVehicleType.applyFlatRate == 1) {
      setApplyFlatRate(true);
      tripSheetData.flatRate = double.tryParse(selectedRoute.flatRate ?? "0.0");
    } else {
      setApplyFlatRate(false);
      tripSheetData.flatRate = 0.0;
    }

    notifyListeners();
  }



  void setApplyFlatRate(bool? applyflatRate) {
    applyFlatRate = applyflatRate ?? false;
    tripSheetData.applyFlatRate = applyflatRate == true ? 1 : 0;
    notifyListeners();
  }

  void setSelectedDeductionAmount(String? amt) {
    deductionController.value = deductionController.value.copyWith(
      text: amt ?? '',
      selection: TextSelection.collapsed(offset: (amt ?? '').length),
    );

    tripSheetData.deduction = double.tryParse(amt ?? "");
    notifyListeners();
  }

  void setSelectedRope(String? ropeData) {
    tripSheetData.rope = ropeData;
    Logger().i(tripSheetData.rope);
    notifyListeners();
  }

  String? transcode;
  String? oldtransportercode;
  String? transname;

  void setSelectedCartNo(String? cartNo,BuildContext context) async {
    cartinfo =
        await AddTripSheetServices().cartInfo(cartNo.toString()) ?? CartInfo();
    Logger().i(cartinfo.toJson());
    if (cartinfo.name==null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'There is no cart info available for that cart number.',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          duration: Duration(seconds: 3), // Adjust the duration as needed
        ),
      );
    }
    tripSheetData.cartno = double.tryParse(cartNo ?? "");
    tripSheetData.transporterCode = cartinfo.name;
    tripSheetData.oldTransporterCode = cartinfo.hTNo;
    tripSheetData.transporter = cartinfo.transporterCode;
    tripSheetData.transporterName = cartinfo.transporterName;
    tripSheetData.vehicleType = cartinfo.vehicleType;
    tripSheetData.gangType = cartinfo.gangType;
    tripSheetData.harvesterNameH = cartinfo.harvesterName;
    tripSheetData.harvesterName = cartinfo.harvesterName;
    tripSheetData.harvesterCodeOld = cartinfo.hTNo;
    tripSheetData.harvestingCodeHt = cartinfo.name;
    tripSheetData.harvesterCodeH = cartinfo.harvesterCode;
    boolFlatRte();
    notifyListeners();
  }

  ///////validators//////
  String? validateSeason(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select season';
    }
    return null;
  }

  String? validatePlant(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select Plantr';
    }
    return null;
  }

  String? validatePlotNo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select plot Number';
    }
    return null;
  }

  String? validateRote(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select the route';
    }
    return null;
  }

  String? validateDedAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select plot Number';
    }
    return null;
  }

  String? validateCaneDeductionType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select the Cane Deduction Type';
    }
    return null;
  }

  String? validateCaneDeduction(String? value) {
    // Check if `burnCane` is not empty or null
    if (tripSheetData.burnCane != null && tripSheetData.burnCane!.isNotEmpty) {
      // If `burnCane` has a value, ensure `deduction` is not empty
      if (value == null || value.isEmpty) {
        return 'Please enter the deduction';
      }
    }
    return null;
  }

  String? validateTrans(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select\n the Transporter';
    }
    return null;
  }

  String? validateRope(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select Rope';
    }
    return null;
  }

  String? validateCartNo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Cart No';
    }
    return null;
  }
  String? validateVehicleType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Vehicle Type';
    }
    return null;
  }
  String? validateVehicleNumber(String? value) {
    if (tripSheetData.vehicleType!="BULLOCK CART"){
    if (value == null || value.isEmpty) {
      return 'Please Enter Vehicle Number';
    }}
    return null;
  }
  String? validateGangType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Gang Type';
    }
    return null;
  }

  String? validateHar(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter\n harvester code';
    }
    return null;
  }
  String? validate(String? value) {
  // If vehicleType is "TRACTOR" or "TRACTOR CART", Tolly 2 is mandatory
  if (tripSheetData.vehicleType == "TRACTOR" || tripSheetData.vehicleType == "TRACTOR CART") {
  if (value == null || value.isEmpty) {
  return 'Please enter Tolly 1 and Tolly 2';
  }
  }
  return null;
  }
  String? validateWaterShare(String? value) {
    // Check if the watersupplier field is present (not null or empty)
    if (tripSheetData.waterSupplier != null && tripSheetData.waterSupplier!.isNotEmpty) {
      // If watersupplier is present, waterShare becomes mandatory
      if (value == null || value.isEmpty) {
        return 'Please Enter Water Share';
      }
    }
    return null;
  }


  @override
  void dispose() {
    // TODO: implement dispose
engineNumberController.dispose();
tolly2Controller.dispose();
tolly1Controller.dispose();
deductionController.dispose();
slipnoController.dispose();
    super.dispose();
  }
}
