import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:sugar_mill_app/views/cane_screens/list_cane_view/list_cane_model.dart';
import 'package:sugar_mill_app/widgets/full_screen_loader.dart';
import '../../../router.router.dart';
import '../../../widgets/cdrop_down_widget.dart';
import '../../../widgets/error_widget.dart';

class ListCaneScreen extends StatelessWidget {
  const ListCaneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListCaneModel>.reactive(
      viewModelBuilder: () => ListCaneModel(),
      onViewModelReady: (model) => model.initialise(context),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const AutoSizeText(
            'Cane Master',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Routes.addCaneScreen,
                    arguments: const AddCaneScreenArguments(caneId: ""),
                  );
                },
                child: const AutoSizeText('+Add Cane Master')),
          ],
        ),
        body: shimmerListView(
          child: RefreshIndicator(
            onRefresh: model.refresh,
            child: Column(
              children: [
                // Filter Section with Drop-downs and Search Fields
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 100,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CdropDown(
                              dropdownButton: DropdownButtonFormField<String>(
                                isExpanded: true,
                                // Replace null with the selected value if needed
                                decoration: const InputDecoration(
                                  labelText: 'Season',
                                ),
                                value: model.seasonController.text,
                                hint: const Text('Select Season'),
                                items: model.seasonlist.map((val) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: AutoSizeText(val),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  model.seasonController.text = value ?? "";
                                  model.filterListByNameAndVillage(
                                      season: value);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              // controller: model.villageController,
                              onChanged: (value) {
                                model.plotController.text = value;
                                model.filterListByNameAndVillage(
                                    plotNo: value);
                              },
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Plot No',

                                // prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              // controller: model.villageController,
                              onChanged: (value) {
                                model.idController.text = value;
                                model.filterListByNameAndVillage(
                                    village: value);
                              },
                              decoration: const InputDecoration(
                                labelText: 'Route',

                                // prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              onChanged: (value) {
                                model.nameController.text = value;
                                model.filterListByNameAndVillage(name: value);
                              },
                              decoration: const InputDecoration(
                                labelText: 'Farmer Name',
                                // prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5.0)
                        ],
                      ),
                    ),
                  ),
                ),
                // Cane List Section
                model.canefilterList.isNotEmpty
                    ? Expanded(
                  child: ListView.separated(
                    itemCount: model.canefilterList.length,
                    itemBuilder: (context, index) {
                      final cane = model.canefilterList[index];
                      final cardColor = model.getTileColor(cane.plantationStatus);

                      return
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [cardColor, Colors.white],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 8.0,
                                spreadRadius: 3.0,
                                offset: const Offset(2, 4),
                              ),
                            ],
                            border: Border.all(color: Colors.blueAccent, width: 0.5),
                          ),
                          child: MaterialButton(
                            onPressed: () => model.onRowClick(context, cane),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top Row (Plot number and farmer details)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      cane.plotNo?.toString() ?? "",
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 25),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cane.growerName ?? "",
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('dd-MM-yyyy').format(
                                              DateTime.parse(cane.plantattionRatooningDate ?? ""),
                                            ),
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12.0),

                                // Bottom Row (Crop variety and village/route)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Survey Number'),
                                        Text(
                                          cane.surveyNumber ?? "N/A",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text('Route'),
                                        Text(
                                          cane.routeName ?? "N/A",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: Colors.transparent,
                        thickness: 0,
                      );
                    },
                  ),
                )
                    : customErrorMessage(),
              ],
            ),
          ),
          context: context,
          loader: model.isBusy,
        ),
      ),
    );
  }
}
