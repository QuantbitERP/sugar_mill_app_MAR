import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import '../../../constants.dart';
import '../../../models/list_crop_sampling_model.dart';
import '../../../router.router.dart';
import '../../../services/add_cane_service.dart';
import '../../../services/list_crop_sampling_service.dart';

class ListCompletedSamplingModel extends BaseViewModel {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController seasoncontroller = TextEditingController();
  TextEditingController villagecontroller = TextEditingController();
  TextEditingController plotController = TextEditingController();

  List<ListSampling> samplingList = [];
  List<ListSampling> filtersamplingList = [];
  String caneSeasonFilter = "";
  String caneVillageFilter = "";
  String caneNameFilter = "";
  String canePlotFilter = "";

  List<String> seasonlist = [""];
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
      seasonlist = await AddCaneService().fetchSeason();

      if (seasonlist.isEmpty) {
        if (context.mounted) logout(context);
        return;
      }

      // Set the latest season and filter the list
      String latestSeason = _getLatestSeason();
      seasoncontroller.text = latestSeason;
      await getListByvillagefarmernameFilter(season: latestSeason);
    } catch (error) {
      // Handle errors appropriately (e.g., logging or showing a snackbar)
      print("Error initializing: $error");
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    if (seasonlist.isEmpty) return;

    String latestSeason = _getLatestSeason();
    seasoncontroller.text = latestSeason;
    await getListByvillagefarmernameFilter(season: latestSeason);
    notifyListeners();
  }

  void onRowClick(BuildContext context, ListSampling? samplingList) {
    Navigator.pushNamed(
      context,
      Routes.addCropSamplingScreen,
      arguments: AddCropSamplingScreenArguments(samplingId: samplingList?.name ?? ""),
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
      filtersamplingList = await ListCropSamplingServices()
          .getCompletedListByvillagefarmernameFilter(
        caneVillageFilter,
        caneNameFilter,
        caneSeasonFilter,
        canePlotFilter,
      );
    } catch (error) {
      // Handle fetch errors
      print("Error fetching filtered list: $error");
    } finally {
      notifyListeners();
    }
  }

  /// Helper method to determine the latest season.
  String _getLatestSeason() {
    int currentYear = DateTime.now().year;
    return seasonlist.firstWhere(
          (season) => season.startsWith("$currentYear-"),
      orElse: () => seasonlist.last,
    );
  }

}
