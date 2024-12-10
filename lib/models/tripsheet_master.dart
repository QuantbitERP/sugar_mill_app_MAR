class TripSheetMasters {
  List<String>? season;
  List<String>? plant;
  List<String>? gangType;
  List<TransportInfo>? transportInfo;
  List<WaterSupplierList>? waterSupplierList;
  List<CaneRoute>? caneRoute;
  List<VehicleType>? vehicleType;
  List<String>? rope;

  TripSheetMasters(
      {this.season,
        this.plant,
        this.gangType,
        this.transportInfo,
        this.waterSupplierList,
        this.caneRoute,
        this.vehicleType,
      this.rope});

  TripSheetMasters.fromJson(Map<String, dynamic> json) {
    season = json['season'].cast<String>();
    rope = json['rope_type'].cast<String>();
    plant = json['plant'].cast<String>();
    gangType = json['gang_type'].cast<String>();

    if (json['Transport_Info'] != null) {
      transportInfo = <TransportInfo>[];
      json['Transport_Info'].forEach((v) {
        transportInfo!.add(TransportInfo.fromJson(v));
      });
    }
    if (json['Water_Supplier_List'] != null) {
      waterSupplierList = <WaterSupplierList>[];
      json['Water_Supplier_List'].forEach((v) {
        waterSupplierList!.add(WaterSupplierList.fromJson(v));
      });
    }
    if (json['cane_route'] != null) {
      caneRoute = <CaneRoute>[];
      json['cane_route'].forEach((v) {
        caneRoute!.add(CaneRoute.fromJson(v));
      });
    }
    if (json['vehicle_type'] != null) {
      vehicleType = <VehicleType>[];
      json['vehicle_type'].forEach((v) {
        vehicleType!.add(VehicleType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['season'] = season;
    data['plant'] = plant;
    data['gang_type']=gangType;
    data['rope_type']=rope;
    if (transportInfo != null) {
      data['Transport_Info'] =
          transportInfo!.map((v) => v.toJson()).toList();
    }
    if (waterSupplierList != null) {
      data['Water_Supplier_List'] =
          waterSupplierList!.map((v) => v.toJson()).toList();
    }
    if (caneRoute != null) {
      data['cane_route'] = caneRoute!.map((v) => v.toJson()).toList();
    }
    if (vehicleType != null) {
      data['vehicle_type'] = vehicleType!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TransportInfo {
  String? name;
  String? season;
  String? oldNo;
  int? dummyContract;
  String? transporterName;
  String? transporterCode;
  String? harvesterCode;
  String? harvesterName;
  String? vehicleType;
  String? vehicleNo;
  String? trolly1;
  String? trolly2;
  String? gangType;

  TransportInfo(
      {this.name,
        this.oldNo,
        this.dummyContract,
        this.transporterName,
        this.transporterCode,
        this.season,
        this.harvesterCode,
        this.harvesterName,
        this.vehicleType,
        this.vehicleNo,
        this.trolly1,
        this.trolly2,
        this.gangType});

  TransportInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    oldNo = json['old_no'];
    dummyContract=json['dummy_contract'];
    transporterName = json['transporter_name'];
    transporterCode = json['transporter_code'];
    season=json['season'];
    harvesterCode = json['harvester_code'];
    harvesterName = json['harvester_name'];
    vehicleType = json['vehicle_type'];
    vehicleNo = json['vehicle_no'];
    trolly1 = json['trolly_1'];
    trolly2 = json['trolly_2'];
    gangType = json['gang_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['old_no'] = oldNo;
    data['dummy_contract']=dummyContract;
    data['transporter_name'] = transporterName;
    data['transporter_code'] = transporterCode;
    data['harvester_code'] = harvesterCode;
    data['season']=season;
    data['harvester_name'] = harvesterName;
    data['vehicle_type'] = vehicleType;
    data['vehicle_no'] = vehicleNo;
    data['trolly_1'] = trolly1;
    data['trolly_2'] = trolly2;
    data['gang_type'] = gangType;
    return data;
  }
}

class WaterSupplierList {
  String? name;
  String? supplierName;
  String? existingSupplierCode;

  WaterSupplierList({this.name, this.supplierName, this.existingSupplierCode});

  WaterSupplierList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    supplierName = json['supplier_name'];
    existingSupplierCode = json['existing_supplier_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['supplier_name'] = supplierName;
    data['existing_supplier_code'] = existingSupplierCode;
    return data;
  }
}

class CaneRoute {
  String? route;
  double? distanceKm;
  String? name;
  String? taluka;
  String? circleOffice;
  String? village;
  int? applyFlatRate;
  String? flatRate;

  CaneRoute(
      {this.route,
        this.distanceKm,
        this.name,
        this.taluka,
        this.circleOffice,
        this.village,
        this.applyFlatRate,
        this.flatRate});

  CaneRoute.fromJson(Map<String, dynamic> json) {
    route = json['route'];
    distanceKm = json['distance_km'];
    name = json['name'];
    taluka = json['taluka'];
    circleOffice = json['circle_office'];
    village = json['village'];
    applyFlatRate = json['apply_flat_rate'];
    flatRate = json['flat_rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['route'] = route;
    data['distance_km'] = distanceKm;
    data['name'] = name;
    data['taluka'] = taluka;
    data['circle_office'] = circleOffice;
    data['village'] = village;
    data['apply_flat_rate'] = applyFlatRate;
    data['flat_rate'] = flatRate;
    return data;
  }
}

class VehicleType {
  String? name;
  int? applyFlatRate;

  VehicleType({this.name, this.applyFlatRate});

  VehicleType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    applyFlatRate = json['apply_flat_rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['apply_flat_rate'] = applyFlatRate;
    return data;
  }
}
