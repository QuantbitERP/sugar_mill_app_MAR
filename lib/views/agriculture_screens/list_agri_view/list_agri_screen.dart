import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:sugar_mill_app/views/agriculture_screens/list_agri_view/list_agri_model.dart';
import 'package:sugar_mill_app/widgets/full_screen_loader.dart';
import '../../../router.router.dart';
import '../../../widgets/cdrop_down_widget.dart';
import '../../../widgets/error_widget.dart';

class ListAgriScreen extends StatelessWidget {
  const ListAgriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListAgriModel>.reactive(
      viewModelBuilder: () => ListAgriModel(),
      onViewModelReady: (model) => model.initialise(context),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const AutoSizeText('Agriculture Development List'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Routes.addAgriScreen,
                    arguments: const AddAgriScreenArguments(agriId: ""),
                  );
                },
                child: const AutoSizeText('+Add Cane Development')),
          ],
        ),
        body: shimmerListView(
          child: RefreshIndicator(
            onRefresh: model.refresh,
            child: Column(
              children: [
                // Filter Section
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
                                decoration: const InputDecoration(
                                  labelText: 'Season',
                                ),
                                hint: const Text('Select Season'),
                                value: model.seasonController.text,
                                items: model.seasonList.map((val) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: AutoSizeText(val),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  model.seasonController.text = value ?? "";
                                  model.filterListBySeason(name: value);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              onChanged: (value) {
                                model.plotController.text = value;
                                model.getAgriListByVillageFarmerNameFilter(
                                    plot: value);
                              },
                              decoration: const InputDecoration(
                                labelText: 'Plot No',
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              onChanged: (value) {
                                model.villageController.text = value;
                                model.getAgriListByVillageFarmerNameFilter(
                                    village: value);
                              },
                              decoration: const InputDecoration(
                                labelText: 'Village',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              onChanged: (value) {
                                model.nameController.text = value;
                                model.getAgriListByVillageFarmerNameFilter(
                                    name: value);
                              },
                              decoration: const InputDecoration(
                                labelText: 'Farmer Name',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                // Agri List Section
                model.filteredAgriList.isNotEmpty
                    ? Expanded(
                  child: ListView.separated(
                    itemCount: model.filteredAgriList.length,
                    itemBuilder: (context, index) {
                      final agri = model.filteredAgriList[index];
                      final cardColor = agri.docstatus == 0
                          ? Colors.grey.shade200
                          : const Color(0xFFD3E8FD);

                      return Padding(
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
                            onPressed: () => model.onRowClick(context, agri),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top Row (Plot number and farmer details)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      agri.plotNo ?? "",
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 25),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            agri.growerName ?? "",
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            agri.date != null && agri.date!.isNotEmpty
                                                ? DateFormat('dd-MM-yyyy').format(
                                                DateTime.parse(agri.date ?? "")
                                            )
                                                : "",
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14.0,
                                            ),
                                          )

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
                                        const Text('Crop Variety'),
                                        Text(
                                          agri.cropVariety ?? "N/A",
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
                                        const Text('Village/Route'),
                                        Text(
                                          agri.village ?? "N/A",
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
                    separatorBuilder: (context, index) => const SizedBox(height: 10.0),
                  ),
                )
                    : customErrorMessage()
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
