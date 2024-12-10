import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../widgets/cdrop_down_widget.dart';
import '../../../widgets/ctext_button.dart';
import '../../../widgets/full_screen_loader.dart';
import 'add_crop_sampling_model.dart';

class AddCropSamplingScreen extends StatelessWidget {
  final String samplingId;
  const AddCropSamplingScreen({super.key, required this.samplingId});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddCropSmaplingModel>.reactive(
        viewModelBuilder: () => AddCropSmaplingModel(),
        onViewModelReady: (model) => model.initialise(context, samplingId),
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              title: model.isEdit == true
                  ? Text(model.cropsamplingdata.name ?? "")
                  : const Text('Crop Sampling'),
            ),
            body: shimmerForm(
              child: SingleChildScrollView(
                child: Form(
                  key: model.formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: [
                      CdropDown(
                        dropdownButton:
                        DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: model.cropsamplingdata.season,
                          // Replace null with the selected value if needed
                          decoration: const InputDecoration(
                            labelText: 'Season *',
                          ),
                          hint: const Text('Select Season'),
                          items: model.seasonlist.map((val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: AutoSizeText(val),
                            );
                          }).toList(),
                          onChanged: (value) =>
                              model.setSelectedseason(value),
                          validator: model.validateseason,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Autocomplete<String>(
                              key: Key(model.cropsamplingdata.area ?? "03"),
                              initialValue: TextEditingValue(
                                text: model.cropsamplingdata.area ?? "",
                              ),
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<String>.empty();
                                }
                                return model.villagelist
                                    .map((route) => route.name ?? "")
                                    .toList()
                                    .where((route) => route
                                    .toLowerCase()
                                    .contains(textEditingValue.text
                                    .toLowerCase()));
                              },
                              onSelected: (String routeName) {
                                // Find the corresponding route object
                                final routeData = model.villagelist
                                    .firstWhere(
                                        (route) => route.name == routeName);
                                model.setSelectedVillage(context,
                                    routeData.name); // Pass the route
                              },
                              fieldViewBuilder: (BuildContext context,
                                  TextEditingController
                                  textEditingController,
                                  FocusNode focusNode,
                                  VoidCallback onFieldSubmitted) {
                                return TextFormField(
                                  // key: Key(model.farmerData.village ?? ""),
                                  // initialValue: model.farmerData.village,
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  decoration: const InputDecoration(
                                    labelText: 'Plot Village *',
                                  ),
                                  onChanged: (String value) {},
                                  validator: model.validatevillage,
                                );
                              },
                              optionsViewBuilder: (BuildContext contpext,
                                  AutocompleteOnSelected<String> onSelected,
                                  Iterable<String> options) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    elevation: 4.0,
                                    child: Container(
                                      constraints: const BoxConstraints(
                                          maxHeight: 200),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: options.length,
                                        itemBuilder: (BuildContext context,
                                            int index) {
                                          final String option =
                                          options.elementAt(index);
                                          return GestureDetector(
                                            onTap: () {
                                              onSelected(option);
                                            },
                                            child: ListTile(
                                              title: Text(option),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                              optionsMaxHeight: 200,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                              child:  TextFormField(
                                key: Key(model.cropsamplingdata.circleOffice ??
                                    "circleOffice"),
                                readOnly: true,
                                initialValue:
                                model.cropsamplingdata.circleOffice ?? "",
                                decoration: const InputDecoration(
                                  labelText: 'Plot circle office',
                                ),
                                onChanged: model.setSelectedfarmername,
                              )),
                        ],
                      ),
                      Row(children: [
                        Expanded(
                          flex: 3,
                          child: Autocomplete<String>(
                            key: Key(model.cropsamplingdata.growerName ?? "05"),
                            initialValue: TextEditingValue(
                              text: model.cropsamplingdata.growerName ?? "",
                            ),
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                              if (textEditingValue.text.isEmpty) {
                                return const Iterable<String>.empty();
                              }
                              return model.farmerlist
                                  .where((grower) =>
                                  (grower.supplierName ?? "")
                                      .toLowerCase()
                                      .contains(textEditingValue.text
                                      .toLowerCase()))
                                  .map((grower) =>
                              grower.supplierName ?? "")
                                  .toList();
                            },
                            onSelected:(String routeName) {
                          // Find the corresponding route object
                          final routeData = model.farmerlist
                              .firstWhere((route) =>
                    route.supplierName ==
                    routeName);
                  model.setSelectedgrowername(context,
                  routeData.supplierName); // Pass the route
            },
                            fieldViewBuilder: (BuildContext context,
                                TextEditingController textEditingController,
                                FocusNode focusNode,
                                VoidCallback onFieldSubmitted) {
                              return TextFormField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                decoration: const InputDecoration(
                                  labelText: 'Grower Name *',
                                ),
                                onChanged: (String value) {},
                                validator: model.validatefarmer,
                              );
                            },
                            optionsViewBuilder: (BuildContext context,
                                AutocompleteOnSelected<String> onSelected,
                                Iterable<String> options) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  elevation: 4.0,
                                  child: Container(
                                    constraints: const BoxConstraints(
                                        maxHeight: 200),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: options.length,
                                      itemBuilder: (BuildContext context,
                                          int index) {
                                        final String option =
                                        options.elementAt(index);
                                        final routeData = model.farmerlist
                                            .firstWhere((route) =>
                                        route
                                            .supplierName ==
                                            option);
                                        return GestureDetector(
                                          onTap: () {
                                            onSelected(option);
                                          },
                                          child: ListTile(
                                            title: Text(option),
                                            subtitle: Text(
                                                routeData.existingSupplierCode!),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                            optionsMaxHeight: 200,
                          ),
                        ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          flex: 1,
                          //for plant
                          child: TextFormField(
                              key: Key(
                                  model.cropsamplingdata.growerCode ??
                                      "supplier"),
                              readOnly: true,
                              initialValue: model.selectedfarcode ??
                                  "",
                              decoration: const InputDecoration(
                                labelText: 'Grower Code',
                              ),
                              onChanged: model.setSelectedVendor),
                        ),
                      ]),

                      Row(
                        children: [
                          Expanded(
                            child:
                            TextFormField(
                                key: Key(
                                    model.cropsamplingdata.plotNo ??
                                        "plotNo"),
                                readOnly: true,
                                initialValue:  model.cropsamplingdata.plotNo ??
                                    "",
                                decoration: const InputDecoration(
                                  labelText: 'Plot No.',
                                ),
                                onChanged: model.setSelectedVendor),
                            // CdropDown(
                            //   dropdownButton: DropdownButtonFormField<String>(
                            //     key: Key(model.cropsamplingdata.id ?? "plotno"),
                            //     isExpanded: true,
                            //     value: model.cropsamplingdata.id,
                            //     decoration: const InputDecoration(
                            //       labelText: 'Plot Number *',
                            //     ),
                            //     hint: const Text('Select plot number'),
                            //     items: model.plotList.map((val) {
                            //       return DropdownMenuItem<String>(
                            //         value: val.name.toString(),
                            //         child: AutoSizeText(val.name.toString()),
                            //       );
                            //     }).toList(),
                            //     onChanged: (value) => model.setSelectedplot(value),
                            //     validator: model.validateplotNumber,
                            //   ),
                            // ),

                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Expanded(
                            child: TextFormField(
                              key: Key(
                                  model.cropsamplingdata.plantName ??
                                      "branch"),
                              readOnly: true,
                              initialValue:
                                  model.cropsamplingdata.plantName ??
                                      "",
                              decoration: const InputDecoration(
                                labelText: 'Plant',
                              ),
                              onChanged: model.setSelectedPlantName,
                            ),
                          ),


                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              key: Key(
                                  model.cropsamplingdata.cropVariety ??
                                      "cropVariety"),
                              readOnly: true,
                              initialValue:
                                  model.cropsamplingdata.cropVariety ??
                                      "",
                              decoration: const InputDecoration(
                                labelText: 'Crop Variety',
                              ),
                              onChanged: model.setSelectedcropvariety,
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Expanded(
                            child: TextFormField(
                              key: Key(
                                  model.cropsamplingdata.cropType ??
                                      "cropType"),
                              readOnly: true,
                              initialValue:
                                  model.cropsamplingdata.cropType ?? "",
                              decoration: const InputDecoration(
                                labelText: 'Crop Type',
                              ),
                              onChanged: model.setSelectedcroptype,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              key: Key(
                                  model.cropsamplingdata.areaAcrs?.toString() ??
                                      "areaAcrs"),
                              readOnly: true,
                              initialValue:
                              model.cropsamplingdata.areaAcrs?.toString() ??
                                  "",
                              decoration: const InputDecoration(
                                labelText: 'Area in Acrs',
                              ),
                              onChanged: model.setSelectedareainacrs,
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Expanded(
                            child: TextFormField(
                              key: Key(
                                  model.cropsamplingdata.plantattionRatooningDate ??
                                      "plantattionRatooningDate"),
                              readOnly: true,
                              initialValue:
                              model.cropsamplingdata.plantattionRatooningDate ?? "",
                              decoration: const InputDecoration(
                                labelText: 'Plantation date',
                              ),
                              onChanged: model.setSelectedPlantationDate,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: model.brixbottmAreaController,
                              decoration: const InputDecoration(
                                labelText: 'Brix Bottom *',
                              ),
                              onChanged: model.setSelectedbrixbottm,
                              validator: model.validatebrixbottom,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: model.brixmiddleController,
                              decoration: const InputDecoration(
                                labelText: 'Brix Middle *',
                              ),
                              onChanged: model.setSelectedbrixmiddle,
                              validator: model.validatebrixMiddle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: model.brixtopController,
                              decoration: const InputDecoration(
                                labelText: 'Brix Top *',
                              ),
                              onChanged: model.setSelectedbrixtop,
                              validator: model.validatebrixtop,
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),Expanded(
                            child: TextFormField(
                              readOnly: true,
                              key: Key(model
                                  .cropsamplingdata.averageBrix
                                  .toString()),
                              initialValue: model
                                  .cropsamplingdata.averageBrix
                                  ?.toStringAsPrecision(4) ??
                                  "",
                              decoration: InputDecoration(
                                  labelText: 'Average Brixs *',
                                  errorText: model.cropsamplingdata
                                      .averageBrix !=
                                      null &&
                                      (int.tryParse(model
                                          .samplingformauladata
                                          .minimumBrix ??
                                          "") ??
                                          0) >
                                          (model.cropsamplingdata
                                              .averageBrix ??
                                              0.0)
                                      ? 'SugarCane Is not enough Matured to cut down'
                                      : null,
                                  errorMaxLines: 2),
                            ),
                          ),

                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: model.noofpairsController,
                        decoration: InputDecoration(
                            labelText: 'No. of internodes *',
                            errorText: (model
                                .cropsamplingdata.noOfPairs !=
                                null &&
                                (int.tryParse(model
                                    .samplingformauladata
                                    .minimumPairs ??
                                    "") ??
                                    0) >
                                    (model.cropsamplingdata
                                        .noOfPairs ??
                                        0))
                                ? 'SugarCane Is not enough Matured to cut down'
                                : null,
                            errorMaxLines: 3),
                        onChanged: model.setSelectednoofpairs,
                        validator: model.validatenoofpairs,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: CtextButton(
                              text: 'Cancel',
                              onPressed: () => Navigator.of(context).pop(),
                              buttonColor: Colors.red,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: CtextButton(
                              onPressed: () => model.onSavePressed(context),
                              text: 'Save',
                              buttonColor: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
              loader: model.isBusy,
              context: context,
            )));
  }
}
