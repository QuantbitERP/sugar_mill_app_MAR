import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import '../../../widgets/cdrop_down_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/full_screen_loader.dart';
import 'list_sampling_model.dart';

class ListSamplingScreen extends StatelessWidget {
  const ListSamplingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListSamplingModel>.reactive(
      viewModelBuilder: () => ListSamplingModel(),
      onViewModelReady: (model) => model.initialise(context),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const AutoSizeText('To Be Crop Sampling List'),
        ),
        body: shimmerListView(
          child: RefreshIndicator(
            onRefresh: model.refresh,
            child: Column(
              children: [
                // Filters section (Season, Village, Farmer Name)
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
                                value: model.seasonController.text,
                                hint: const Text('Select Season'),
                                items: model.seasonList.map((val) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: AutoSizeText(val),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  model.seasonController.text = value ?? "";
                                  model.getListByvillagefarmernameFilter(season: value);
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
                                model.getListByvillagefarmernameFilter(
                                    plotNo: value);
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
                                model.getListByvillagefarmernameFilter(
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
                                model.getListByvillagefarmernameFilter(
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

                // List of Sampling Items
                model.filterSamplingList.isNotEmpty
                    ? Expanded(
                  child: ListView.separated(
                    itemCount: model.filterSamplingList.length,
                    itemBuilder: (context, index) {
                      final sampling = model.filterSamplingList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [Colors.white54, Colors.white],
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
                            border: Border.all(
                                color: Colors.blueAccent, width: 0.5),
                          ),
                          child: MaterialButton(
                            onPressed: () => model.onRowClick(
                                context, sampling),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                // Top Row (Plot number and farmer details)
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      sampling.plotNo?.toString() ?? "",
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 25),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            sampling.growerName ?? "",
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            sampling.plantattionRatooningDate !=
                                                null
                                                ? DateFormat('dd-MM-yyyy')
                                                .format(
                                              DateTime.parse(sampling
                                                  .plantattionRatooningDate ??
                                                  ""),
                                            )
                                                : "N/A",
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
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Crop Variety
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        const Text('Crop Variety'),
                                        Text(
                                          sampling.cropVariety ?? "N/A",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Village
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        const Text('Village'),
                                        Text(
                                          sampling.area ?? "N/A",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Average Brix
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        const Text('Avg. Brix'),
                                        Text(
                                          sampling.averageBrix != null
                                              ? sampling.averageBrix!
                                              .toStringAsFixed(2)
                                              : "N/A",
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
                        color: Colors.white,
                        thickness: 0,
                      );
                    },
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
