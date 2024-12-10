import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import '../../../constants.dart';
import '../../../models/list_crop_sampling_model.dart';
import '../../../router.router.dart';
import '../../../services/add_cane_service.dart';
import '../../../services/list_crop_sampling_service.dart';

class ListSamplingModel extends BaseViewModel {
  TextEditingController nameController = TextEditingController();
  TextEditingController seasonController = TextEditingController();
  TextEditingController villageController = TextEditingController();
  TextEditingController plotController = TextEditingController();

  List<ListSampling> samplingList = [];
  List<ListSampling> filterSamplingList = [];
  String caneSeasonFilter = "";
  String caneVillageFilter = "";
  String caneNameFilter = "";
  String canePlotFilter = "";
  List<String> seasonList = [""];
  TextEditingController idcontroller = TextEditingController();
  Color getTileColor(String? plantationStatus) {
    switch (plantationStatus) {
      case 'New':
        return const Color(0xFFD3E8FD);
      case 'To Sampling':
        return const Color(0xFFEAF5EE);
      case 'To Harvesting':
        return const Color(0xFFFFF5F5);
      default:
        return const Color(0xFF404944);
    }
  }
  Future<void> initialise(BuildContext context) async {
    setBusy(true);

    try {
      // Fetch the season list
      seasonList = await AddCaneService().fetchSeason();

      if (seasonList.isEmpty) {
        if (context.mounted) logout(context);
        return;
      }

      // Set the latest season and filter the list
      String latestSeason = _getLatestSeason();
      seasonController.text = latestSeason;
      await getListByvillagefarmernameFilter(season: latestSeason);
    } catch (error) {
      print("Error during initialization: $error");
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    if (seasonList.isEmpty) return;

    String latestSeason = _getLatestSeason();
    seasonController.text = latestSeason;

    await getListByvillagefarmernameFilter(season: latestSeason);
    notifyListeners();
  }

  void onRowClick(BuildContext context, ListSampling? samplingList) {
    Navigator.pushNamed(
      context,
      Routes.addCropSamplingScreen,
      arguments: AddCropSamplingScreenArguments(
        samplingId: samplingList?.name ?? "",
      ),
    );
  }

  Future<void> getListByvillagefarmernameFilter({
    String? village,
    String? name,
    String? season,
    String? plotNo,
  }) async {
    // Update filters
    caneNameFilter = name ?? caneNameFilter;
    caneVillageFilter = village ?? caneVillageFilter;
    caneSeasonFilter = season ?? caneSeasonFilter;
    canePlotFilter = plotNo ?? canePlotFilter;

    try {
      // Fetch filtered list
      filterSamplingList = await ListCropSamplingServices()
          .getListByvillagefarmernameFilter(
        caneVillageFilter,
        caneNameFilter,
        caneSeasonFilter,
        canePlotFilter,
      );
    } catch (error) {
      print("Error fetching filtered list: $error");
    } finally {
      notifyListeners();
    }
  }

  /// Private helper method to determine the latest season
  String _getLatestSeason() {
    int currentYear = DateTime.now().year;
    return seasonList.firstWhere(
          (season) => season.startsWith("$currentYear-"),
      orElse: () => seasonList.last,
    );
  }

}
