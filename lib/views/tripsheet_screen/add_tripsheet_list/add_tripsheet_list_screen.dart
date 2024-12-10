import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:sugar_mill_app/widgets/full_screen_loader.dart';

import '../../../constants.dart';
import '../../../router.router.dart';
import '../../../widgets/cdrop_down_widget.dart';
import '../../../widgets/error_widget.dart';
import 'add_tripsheet_list_model.dart';

class TripsheetMaster extends StatelessWidget {
  const TripsheetMaster({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListTripsheet>.reactive(
      viewModelBuilder: () => ListTripsheet(),
      onViewModelReady: (model) => model.initialise(context),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const AutoSizeText('Trip Sheet List'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Routes.addTripSheetScreen,
                    arguments: const AddTripSheetScreenArguments(tripId: ""),
                  );
                },
                child: const AutoSizeText('+Add Trip Sheet')),
          ],
        ),
        body: shimmerListView(
            child: RefreshIndicator(
              onRefresh: model.refresh,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        width: getWidth(context) / 4,
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          // controller: model.villageController,
                                          onChanged: (value) {
                                            model.idcontroller.text = value;
                                            model.filterList("slip_no", value);
                                          },
                                          decoration: const InputDecoration(
                                            labelText: 'ID',

                                            // prefixIcon: Icon(Icons.search),
                                          ),
                                        ),
                                      ),
                                      // child: TextField(
                                      //   onChanged: (value) {
                                      //     model.idcontroller.text = value;
                                      //     model.filterList(
                                      //         "name", int.parse(value));
                                      //   },
                                      //   decoration: const InputDecoration(
                                      //       labelText: 'Id',
                                      //       icon: Icon(Icons.search)),
                                      // ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                      child: TextField(
                                          // controller: model.villageController,
                                          onChanged: (value) {
                                            model.namecontroller.text = value;
                                            model.filterListByNameAndVillage(
                                                village: value);
                                          },
                                          decoration: const InputDecoration(
                                            labelText: 'Village',
                                          )),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    SizedBox(
                                      width: getWidth(context) / 4,
                                      child: TextField(
                                        // controller: model.villageController,
                                        onChanged: (value) {
                                          model.namecontroller.text = value;
                                          model.filterListByNameAndVillage(
                                              transName: value);
                                        },
                                        decoration: const InputDecoration(
                                          labelText: 'Farmer',

                                          // prefixIcon: Icon(Icons.search),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                      child: CdropDown(
                                        dropdownButton:
                                            DropdownButtonFormField<String>(
                                          isExpanded: true,
                                          // Replace null with the selected value if needed
                                          decoration: const InputDecoration(
                                            labelText: 'Season',
                                          ),
                                          value: model.seasonController.text,
                                          hint: const Text('Select Season'),
                                          items: model.seasonList.map((val) {
                                            return DropdownMenuItem<String>(
                                              value: val,
                                              child: Text(val),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            model.seasonController.text =
                                                value ?? "";
                                            model.filterListByNameAndVillage(
                                                season: value);
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10.0),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),


                  model.tripSheetFilter.isNotEmpty
                      ? Expanded(
                          child: ListView.separated(
                            itemCount: model.tripSheetFilter.length,
                            itemBuilder: (context, index) {
                              return
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
                                    border: Border.all(color: Colors.blueAccent, width: 0.5),
                                  ),
                                  child: MaterialButton(
                                    onPressed: () {
                                      model.onRowClick(context, model.tripSheetFilter[index]);
                                    },
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Top Row (Supplier name and code)
                                      Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                      .spaceBetween,
                                      children: [
                                        Text(
                                          model.tripSheetFilter[index].slipNo.toString(),
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 24.0,
                                          ),
                                        ),
                                        const SizedBox(width: 40),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                model.tripSheetFilter[index]
                                                    .farmerName ??
                                                    "",
                                                style: const TextStyle(
                                                  fontSize: 17.0,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),]),
                                        const SizedBox(height: 12.0),
                                        // Bottom Row (Village and Circle)
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Village
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text('Village'),
                                                Text(
                                                  model.tripSheetFilter[index].fieldVillage ?? "N/A",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Circle
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text('Circle'),
                                                Text(
                                                  model.tripSheetFilter[index].circleOffice ?? "N/A",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12.0), // Add some space before the workflow state card
                                        // Workflow State Card
                                        Container(
                                          width: double.infinity, // Make the card take full width
                                          decoration: BoxDecoration(
                                            color: model.getTileColor(model.tripSheetFilter[index].status ?? ''),
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                                          child: AutoSizeText(
                                            model.tripSheetFilter[index].status ?? '',
                                            minFontSize: 15,
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(
                              color: Colors.white, // Color of the line
                              thickness: 0, // Thickness of the line
                              );// Space between items
                            },
                          ),
                        )
                      : customErrorMessage()
                ],
              ),
            ),
            loader: model.isBusy,
            context: context),
      ),
    );
  }
}
