import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';
import 'package:sugar_mill_app/views/agriculture_screens/add_agri_view/add_agri_model.dart';

import '../../../constants.dart';
import '../../../widgets/cdrop_down_widget.dart';
import '../../../widgets/ctext_button.dart';
import '../../../widgets/full_screen_loader.dart';

class AddAgriScreen extends StatelessWidget {
  final String agriId;

  const AddAgriScreen({super.key, required this.agriId});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AgriViewModel>.reactive(
        viewModelBuilder: () => AgriViewModel(),
        onViewModelReady: (model) => model.initialise(context, agriId),
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  model.isEdit == true
                      ? Text(model.agridata.name ?? "")
                      : const Text('New Agriculture development'),
                  if (model.isEdit == true) const SizedBox(width: 10),
                  if (model.isEdit == true)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: model
                            .getColorForStatus(
                                model.agridata.docstatus.toString())
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        model.agridata.docstatus == 0 ? "Draft" : "Submitted",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          color: model.getColorForStatus(
                              model.agridata.docstatus.toString()),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            body: shimmerForm(
              child: SingleChildScrollView(
                child: Form(
                  key: model.formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: [
                      Row(
                        children: [
                          Expanded(
                            child: CdropDown(
                              dropdownButton: DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: model.agridata.season,
                                // Replace null with the selected value if needed
                                decoration: const InputDecoration(
                                  labelText: 'Season *',
                                ),
                                hint: const Text('Select Season'),
                                items: model.seasonList.map((val) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: AutoSizeText(val),
                                  );
                                }).toList(),
                                onChanged: (value) => model.setSeason(value),
                                validator: model.validateSeason,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: CdropDown(
                              dropdownButton: DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: model.agridata.salesType,
                                // Replace null with the selected value if needed
                                decoration: const InputDecoration(
                                  labelText: 'Sales Type *',
                                ),
                                hint: const Text('Select Sales type'),
                                items: model.salesList.map((val) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: AutoSizeText(val),
                                  );
                                }).toList(),
                                onChanged: (value) =>
                                    model.setSelectedSales(context, value),
                                validator: model.validateSalesType,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Autocomplete<String>(
                        key: Key(model.agridata.farmerVillage ?? "03"),
                        initialValue: TextEditingValue(
                          text: model.agridata.farmerVillage ?? "",
                        ),
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<String>.empty();
                          }
                          return model.villageList
                              .map((route) => route.name ?? "")
                              .toList()
                              .where((route) => route.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase()));
                        },
                        onSelected: (String routeName) {
                          // Find the corresponding route object
                          final routeData = model.villageList
                              .firstWhere((route) => route.name == routeName);
                          model.setSelectedVillage(
                              context, routeData.name); // Pass the route
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          return TextFormField(
                            // key: Key(model.farmerData.village ?? ""),
                            // initialValue: model.farmerData.village,
                            controller: textEditingController,
                            focusNode: focusNode,
                            decoration: const InputDecoration(
                              labelText: 'Village *',
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
                                constraints:
                                    const BoxConstraints(maxHeight: 200),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: options.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
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
                      Row(children: [
                        Expanded(
                          flex: 3,
                          child: Autocomplete<String>(
                            key: Key(model.agridata.growerName ?? "05"),
                            initialValue: TextEditingValue(
                              text: model.agridata.growerName ?? "",
                            ),
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                              if (textEditingValue.text.isEmpty) {
                                return const Iterable<String>.empty();
                              }
                              final searchText =
                                  textEditingValue.text.toLowerCase();
                              return model.farmerList
                                  .where((grower) =>
                                      (grower.supplierName
                                              ?.toLowerCase()
                                              .contains(searchText) ??
                                          false) ||
                                      (grower.existingSupplierCode
                                              ?.toLowerCase()
                                              .contains(searchText) ??
                                          false))
                                  .map((grower) => grower.supplierName ?? "")
                                  .toList();
                            },
                            onSelected: (String? value) {
                              model.setSelectedgrowername(context, value);
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
                                    constraints:
                                        const BoxConstraints(maxHeight: 200),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: options.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final String option =
                                            options.elementAt(index);
                                        final routeData = model.farmerList
                                            .firstWhere((route) =>
                                                route.supplierName == option);
                                        return GestureDetector(
                                          onTap: () {
                                            onSelected(option);
                                          },
                                          child: ListTile(
                                            title: Text(option),
                                            subtitle: Text(routeData
                                                .existingSupplierCode!),
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
                              key: Key(model.agridata.vendorCode ?? "supplier"),
                              readOnly: true,
                              initialValue: model.agridata.vendorCode,
                              decoration: const InputDecoration(
                                labelText: 'Vendor Code',
                              ),
                              onChanged: model.setSelectedVendor),
                        ),
                      ]),
                      Row(
                        children: [
                          Expanded(
                            child: CdropDown(
                              dropdownButton: DropdownButtonFormField<String>(
                                key: Key(model.agridata.plotNo ??
                                    "plotno"),
                                isExpanded: true,
                                value: model.agridata.plotNo,
                                decoration: const InputDecoration(
                                  labelText: 'Plot Number *',
                                ),
                                hint: const Text('Select plot number'),
                                items: model.caneListWithFilter.map((val) {
                                  return DropdownMenuItem<String>(
                                    value: val.plotNo.toString(),
                                    child: AutoSizeText(val.plotNo.toString()),
                                  );
                                }).toList(),
                                onChanged: (value) =>
                                    model.setPlotnumber(value),
                                validator: model.validateplotno,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Expanded(
                            child: TextFormField(
                              key: Key(model.agridata.branch ?? "branch"),
                              readOnly: true,
                              initialValue: model.agridata.branch ?? "",
                              decoration: const InputDecoration(
                                labelText: 'Plant',
                              ),
                              onChanged: model.setSelectedPlantName,
                            ),
                          ),
                        ],
                      ),
                      if (model.agridata.salesType != "Fertilizer")
                        Row(
                          children: [
                            Expanded(
                              child: Autocomplete<String>(
                                key: Key(
                                    model.suppliercode ?? "nurserySupplier"),
                                initialValue: TextEditingValue(
                                  text: model.suppliercode ?? "",
                                ),
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text.isEmpty) {
                                    return const Iterable<String>.empty();
                                  }
                                  return model.supplierList
                                      .map((route) =>
                                          route.supplierName.toString())
                                      .toList()
                                      .where((route) => route
                                          .toLowerCase()
                                          .contains(textEditingValue.text
                                              .toLowerCase()));
                                },
                                onSelected: (String routeName) {
                                  // Find the corresponding route object
                                  final routeData = model.supplierList
                                      .firstWhere((route) =>
                                          route.supplierName == routeName);
                                  model.setsupplier(
                                      routeData.name); // Pass the route
                                },
                                fieldViewBuilder: (BuildContext context,
                                    TextEditingController textEditingController,
                                    FocusNode focusNode,
                                    VoidCallback onFieldSubmitted) {
                                  return TextFormField(
                                    // key: Key(model.farmerData.village ?? ""),
                                    // initialValue: model.farmerData.village,
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    decoration: InputDecoration(
                                      labelText:
                                          '${model.agridata.salesType ?? ""} Supplier *',
                                    ),
                                    onChanged: (String value) {},
                                    validator: model.validateSupplier,
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
                                            final routeData = model.supplierList
                                                .firstWhere((route) =>
                                                    route.supplierName
                                                        .toString() ==
                                                    option);
                                            return GestureDetector(
                                              onTap: () {
                                                onSelected(routeData
                                                    .supplierName
                                                    .toString()); // Send the name as the selected route
                                              },
                                              child: ListTile(
                                                title: Text(option),
                                                subtitle: Text(routeData
                                                    .existingSupplierCode!),
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
                              width: 25,
                            ),
                            Expanded(
                              child: TextFormField(
                                key: Key(model.agridata.supplierName ??
                                    "supplierName"),
                                readOnly: true,
                                initialValue: model.agridata.supplierName ?? "",
                                decoration: const InputDecoration(
                                  labelText: 'Supplier Name',
                                ),
                                onChanged: model.setSelectedsupplier,
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
                                  model.agridata.cropVariety ?? "cropVariety"),
                              readOnly: true,
                              initialValue: model.agridata.cropVariety ?? "",
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
                              key: Key(model.agridata.cropType ?? "cropType"),
                              readOnly: true,
                              initialValue: model.agridata.cropType ?? "",
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
                              key: Key(model.agridata.area.toString()),
                              readOnly: true,
                              initialValue:
                                  model.agridata.area?.toString() ?? "",
                              decoration: const InputDecoration(
                                labelText: 'Area in Acrs',
                              ),
                              onChanged: model.setSelectedAreaInAcrs,
                            ),
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: model.datecontroller,
                              decoration: const InputDecoration(
                                labelText: 'Plantation Date',
                                hintText: 'Select Plantation Date',
                              ),
                              // validator: model.nonrepresentational,
                              onChanged: model.ondateChanged,
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
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            controller: model.developmentAreaController,
                            decoration: InputDecoration(
                              labelText: 'Development Area *',
                              hintText: 'Enter the development area',
                              errorText: (model.agridata.developmentArea ?? 0) >
                                      (model.agridata.area ?? 0)
                                  ? 'Enter valid development area'
                                  : null,
                            ),
                            onChanged: model.setSelecteddevelopmentarea,
                            validator: model.validatedevelopmentArea,
                          )),
                          const SizedBox(
                            width: 25,
                          ),
                          Expanded(
                            child: TextFormField(
                              key: Key(model.agridata.route ?? "km"),
                              readOnly: true,
                              initialValue: model.agridata.route ?? "",
                              decoration: const InputDecoration(
                                labelText: 'K.M.',
                              ),
                              onChanged: model.setSelectedkm,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      if (model.agridata.salesType == "Fertilizer")
                        Wrap(
                          spacing: 4.0,
                          runSpacing: 3.0,
                          alignment: WrapAlignment.center,
                          children: [
                            for (String item in model.items)
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      value: model.selectedItems.contains(item),
                                      onChanged: (_) => model.toggleItem(item),
                                    ),
                                    Text(item),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      if (model.agridata.salesType == "Fertilizer")
                        ElevatedButton(
                            onPressed: () => model.mapJsonToTable(),
                            child: const Text('Update *')),
                      if (model.agridata.salesType != "Fertilizer")
                        ElevatedButton(
                            onPressed: () =>
                                getAgricaultureDetails2(context, model, -1),
                            child: const Text('Add Agriculture *')),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      const Text(
                        'Agriculture Development Item',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      (model.agridata.salesType == 'Fertilizer')
                          ? (model.agricultureDevelopmentItem.isEmpty)
                              ? const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.error,
                                      color: Colors.redAccent,
                                    ),
                                    title: Text(
                                      "No record founds for fertilizer!",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Raleway-Bold',
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columnSpacing: 30.0,
                                    // ignore: deprecated_member_use
                                    border: TableBorder.all(width: 1.0),
                                    columns: const [
                                      DataColumn(
                                        label: Text('Item Name'),
                                      ),
                                      DataColumn(
                                        label: Text('Basel'),
                                      ),
                                      DataColumn(
                                        label: Text('Pre-Earthing'),
                                      ),
                                      DataColumn(
                                        label: Text('Earth'),
                                      ),
                                      DataColumn(
                                        label: Text('Rainy'),
                                      ),
                                      DataColumn(
                                        label: Text('Ratoon1'),
                                      ),
                                      DataColumn(
                                        label: Text('Ratoon2'),
                                      ),
                                      DataColumn(
                                        label: Text('Total'),
                                      ),
                                      DataColumn(
                                        label: Text('Rate'),
                                      ),
                                      DataColumn(
                                        label: Text('Weight Per Unit'),
                                      ),
                                      DataColumn(
                                        label: Text('Total Weight'),
                                      ),
                                      DataColumn(
                                        label: Text('Base Amount'),
                                      ),
                                      DataColumn(
                                        label: Text('Delete'),
                                      ),
                                    ],
                                    rows: List<DataRow>.generate(
                                      model.agricultureDevelopmentItem.length,
                                      // Replace 10 with the actual number of rows you want
                                      (int index) => DataRow(
                                        cells: [
                                          DataCell(Text(
                                            "${model.agricultureDevelopmentItem[index].itemCode.toString()}:${model.agricultureDevelopmentItem[index].itemName.toString()}",
                                            maxLines: 3,
                                            style: TextStyle(
                                                color: ((double.tryParse((model
                                                                    .agricultureDevelopmentItem[
                                                                        index]
                                                                    .actualQty ??
                                                                "")) ??
                                                            0.0) >
                                                        0.0)
                                                    ? Colors.green
                                                    : Colors.red),
                                          )),
                                          DataCell(
                                            TextField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: TextEditingController(
                                                text: (model
                                                            .agricultureDevelopmentItem[
                                                                index]
                                                            .basel ??
                                                        0)
                                                    .toStringAsFixed(0),
                                                // Use an empty string if model.agricultureDevelopmentItem[index].basel is null
                                              ),
                                              onChanged: (value) {
                                                model
                                                    .agricultureDevelopmentItem[
                                                        index]
                                                    .basel = double.tryParse(value);
                                                model.calculateTotal();
                                                model.calculatebaseltotal();
// Set the total to model.agridata.baseltotal
                                                model.calculatetotal();
                                              },
                                            ),
                                          ),
                                          DataCell(
                                            TextField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: TextEditingController(
                                                text: (model
                                                            .agricultureDevelopmentItem[
                                                                index]
                                                            .preEarthing ??
                                                        0)
                                                    .toStringAsFixed(0),
                                              ),
                                              onChanged: (value) {
                                                model
                                                        .agricultureDevelopmentItem[
                                                            index]
                                                        .preEarthing =
                                                    double.parse(value);
                                                model.calculateTotal();
                                                model.calculateprearthtotal();
                                                model.calculatetotal();
                                              },
                                            ),
                                          ),
                                          DataCell(
                                            TextField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: TextEditingController(
                                                text: (model
                                                            .agricultureDevelopmentItem[
                                                                index]
                                                            .earth ??
                                                        0)
                                                    .toStringAsFixed(0),
                                              ),
                                              onChanged: (value) {
                                                model
                                                    .agricultureDevelopmentItem[
                                                        index]
                                                    .earth = double.parse(value);
                                                model.calculateTotal();
                                                model.calculatedearthtotal();
                                                model.calculatetotal();
                                              },
                                            ),
                                          ),
                                          DataCell(
                                            TextField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: TextEditingController(
                                                text: (model
                                                            .agricultureDevelopmentItem[
                                                                index]
                                                            .rainy ??
                                                        0)
                                                    .toStringAsFixed(0),
                                              ),
                                              onChanged: (value) {
                                                model
                                                    .agricultureDevelopmentItem[
                                                        index]
                                                    .rainy = double.parse(value);
                                                model.calculateTotal();
                                                model.calculaterainytotal();
                                                model.calculatetotal();
                                              },
                                            ),
                                          ),
                                          DataCell(
                                            TextField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: TextEditingController(
                                                text: (model
                                                            .agricultureDevelopmentItem[
                                                                index]
                                                            .ratoon1 ??
                                                        0)
                                                    .toStringAsFixed(0),
                                              ),
                                              onChanged: (value) {
                                                model
                                                    .agricultureDevelopmentItem[
                                                        index]
                                                    .ratoon1 = double.parse(value);
                                                model.calculateTotal();
                                                model.calculateratoon1total();
                                                model.calculatetotal();
                                              },
                                            ),
                                          ),
                                          DataCell(
                                            TextField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: TextEditingController(
                                                text: (model
                                                            .agricultureDevelopmentItem[
                                                                index]
                                                            .ratoon2 ??
                                                        0)
                                                    .toStringAsFixed(0),
                                              ),
                                              onChanged: (value) {
                                                model
                                                    .agricultureDevelopmentItem[
                                                        index]
                                                    .ratoon2 = double.parse(value);
                                                model.calculateTotal();
                                                model.calculateratoon2total();
                                                model.calculatetotal();
                                              },
                                            ),
                                          ),
                                          DataCell(Text(
                                            (model.agricultureDevelopmentItem[index]
                                                        .qty ??
                                                    0)
                                                .toStringAsFixed(0),
                                          )),
                                          DataCell(Text(
                                            (model.agricultureDevelopmentItem[index]
                                                        .rate ??
                                                    0)
                                                .toString(),
                                          )),
                                          DataCell(Text(
                                            (model.agricultureDevelopmentItem[index]
                                                        .weightPerUnit ??
                                                    0)
                                                .toString(),
                                          )),
                                          DataCell(Text(
                                            (model.agricultureDevelopmentItem[index]
                                                        .totalWeight ??
                                                    0)
                                                .toString(),
                                          )),
                                          DataCell(Text(
                                            (model.agricultureDevelopmentItem[index]
                                                        .baseAmount ??
                                                    0)
                                                .toString(),
                                          )),
                                          DataCell(IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Confirm Delete'),
                                                    content: const Text(
                                                        'Are you sure you want to delete this Record?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context); // Close the confirmation dialog
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context); // Close the confirmation dialog
                                                          model.deleteAgriAccount(
                                                              index); // Delete the entry
                                                        },
                                                        child: const Text(
                                                            'Delete'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(Icons.delete),
                                          ))
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                          : (model.agricultureDevelopmentItem2.isEmpty)
                              ? const ListTile(
                                  leading: Icon(
                                    Icons.error,
                                    color: Colors.redAccent,
                                  ),
                                  title: Text(
                                    "No record founds for items!",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Raleway-Bold',
                                        fontWeight: FontWeight.w700),
                                  ),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
                                    columnSpacing: 22.0,
                                    border: TableBorder.all(width: 0.5),
                                    // ignore: deprecated_member_use
                                    dataRowHeight: 40.0,
                                    columns: const [
                                      DataColumn(
                                        label: Text('Item code'),
                                      ),
                                      DataColumn(
                                        label: Text('Qty'),
                                      ),
                                      DataColumn(
                                        label: Text('Rate'),
                                      ),
                                      DataColumn(
                                        label: Text('Amount'),
                                      ),
                                      DataColumn(
                                        label: Text('Delete'),
                                        // Add a new DataColumn for the button
                                        numeric: false,
                                      ),
                                    ],
                                    rows: List<DataRow>.generate(
                                      model.agricultureDevelopmentItem2.length,
                                      // Replace 10 with the actual number of rows you want
                                      (int index) => DataRow(
                                        cells: [
                                          DataCell(Text(
                                            "${model.agricultureDevelopmentItem2[index].itemCode.toString()}:${model.agricultureDevelopmentItem2[index].itemName.toString()}",
                                          )),
                                          DataCell(Text((model
                                                      .agricultureDevelopmentItem2[
                                                          index]
                                                      .qty ??
                                                  0)
                                              .toStringAsFixed(0))),
                                          DataCell(Text(model
                                              .agricultureDevelopmentItem2[
                                                  index]
                                              .rate
                                              .toString())),
                                          DataCell(Text(model
                                              .agricultureDevelopmentItem2[
                                                  index]
                                              .amount
                                              .toString())),
                                          DataCell(IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Confirm Delete'),
                                                    content: const Text(
                                                        'Are you sure you want to delete this Record?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context); // Close the confirmation dialog
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context); // Close the confirmation dialog
                                                          model.deleteAgriAccount2(
                                                              index); // Delete the entry
                                                        },
                                                        child: const Text(
                                                            'Delete'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(Icons.delete),
                                          ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                      const SizedBox(
                        height: 15,
                      ),
                      (model.agricultureDevelopmentItem.isNotEmpty &&
                              model.agridata.salesType == 'Fertilizer')
                          ? ElevatedButton(
                              onPressed: () =>
                                  getAgricaultureDetails(context, model, -1),
                              child: const Text(
                                  'Add New Agriculture Development *'))
                          : const SizedBox(),
                      const SizedBox(
                        height: 15,
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      model.agridata.salesType == 'Fertilizer'
                          ? Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    key: Key(
                                        model.agridata.baselTotal.toString()),
                                    readOnly: true,
                                    initialValue: model.agridata.baselTotal
                                            ?.toStringAsFixed(0) ??
                                        "",
                                    decoration: const InputDecoration(
                                      labelText: 'basel Total',
                                    ),
                                    onChanged: model.setbaseltotal,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    key: Key(model.agridata.preEarthingTotal
                                        .toString()),
                                    readOnly: true,
                                    initialValue: model
                                            .agridata.preEarthingTotal
                                            ?.toStringAsFixed(0) ??
                                        "",
                                    decoration: const InputDecoration(
                                      labelText: 'PreEarthing Total',
                                    ),
                                    onChanged: model.setpreeath,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    key: Key(
                                        model.agridata.earthTotal.toString()),
                                    readOnly: true,
                                    initialValue: model.agridata.earthTotal
                                            ?.toStringAsFixed(0) ??
                                        "",
                                    decoration: const InputDecoration(
                                      labelText: 'Earth Total',
                                    ),
                                    onChanged: model.setearthtotal,
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      model.agridata.salesType == 'Fertilizer'
                          ? Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    key: Key(
                                        model.agridata.rainyTotal.toString()),
                                    readOnly: true,
                                    initialValue: model.agridata.rainyTotal
                                            ?.toStringAsFixed(0) ??
                                        "",
                                    decoration: const InputDecoration(
                                      labelText: 'Rainy Total',
                                    ),
                                    onChanged: model.setrainytotal,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    key: Key(
                                        model.agridata.ratoon1Total.toString()),
                                    readOnly: true,
                                    initialValue: model.agridata.ratoon1Total
                                            ?.toStringAsFixed(0) ??
                                        "",
                                    decoration: const InputDecoration(
                                      labelText: 'Ratoon1 Total',
                                    ),
                                    onChanged: model.setratoon1total,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    key: Key(
                                        model.agridata.ratoon2Total.toString()),
                                    readOnly: true,
                                    initialValue: model.agridata.ratoon2Total
                                            ?.toStringAsFixed(0) ??
                                        "",
                                    decoration: const InputDecoration(
                                      labelText: 'Ratoon2 Total',
                                    ),
                                    onChanged: model.setratoon2total,
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      model.agridata.salesType == 'Fertilizer'
                          ? TextFormField(
                              key: Key(model.agridata.total.toString()),
                              readOnly: true,
                              initialValue:
                                  model.agridata.total?.toStringAsFixed(0) ??
                                      "",
                              decoration: const InputDecoration(
                                labelText: 'Total',
                              ),
                              onChanged: model.settotal,
                            )
                          : Container(),
                      if (model.agridata.salesType == 'Fertilizer')
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                key: Key(model.agridata.totalWeight.toString()),
                                readOnly: true,
                                initialValue:
                                    model.agridata.totalWeight?.toString() ??
                                        "",
                                decoration: const InputDecoration(
                                  labelText: 'Total Weight',
                                ),
                                // onChanged: model.setratoon1total,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextFormField(
                                key: Key(
                                    model.agridata.totalBaseAmount.toString()),
                                readOnly: true,
                                initialValue: model.agridata.totalBaseAmount
                                        ?.toString() ??
                                    "",
                                decoration: const InputDecoration(
                                  labelText: 'Total Amount',
                                ),
                                // onChanged: model.setratoon1total,
                              ),
                            ),
                          ],
                        ),
                      const Divider(
                        thickness: 1,
                      ),
                      const Text(
                        'Grantors',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      (model.grantor.isEmpty)
                          ? const ListTile(
                              leading: Icon(
                                Icons.error,
                                color: Colors.redAccent,
                              ),
                              title: Text(
                                "No record founds for grantors!",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Raleway-Bold',
                                    fontWeight: FontWeight.w700),
                              ),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                columnSpacing: 22.0,
                                border: TableBorder.all(width: 0.5),
                                // ignore: deprecated_member_use
                                dataRowHeight: 40.0,
                                columns: const [
                                  DataColumn(
                                    label: Text('Village'),
                                  ),
                                  DataColumn(
                                    label: Text('Surety Code'),
                                  ),
                                  DataColumn(
                                    label: Text('Surety Name'),
                                  ),
                                  DataColumn(
                                    label: Text('Delete'),
                                    // Add a new DataColumn for the button
                                    numeric: false,
                                  ),
                                ],
                                rows: List<DataRow>.generate(
                                  model.grantor.length,
                                  // Replace 10 with the actual number of rows you want
                                  (int index) => DataRow(
                                    cells: [
                                      DataCell(Text(model.grantor[index].village
                                          .toString())),
                                      DataCell(Text(model
                                          .grantor[index].suretyExistingCode
                                          .toString())),
                                      DataCell(Text(model
                                          .grantor[index].suretyName
                                          .toString())),
                                      DataCell(IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Confirm Delete'),
                                                content: const Text(
                                                    'Are you sure you want to delete this Granter?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context); // Close the confirmation dialog
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context); // Close the confirmation dialog
                                                      model.deleteBankAccount(
                                                          index); // Delete the entry
                                                    },
                                                    child: const Text('Delete'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.delete),
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      ElevatedButton(
                        onPressed: () => getGrantorDetails(context, model, -1),
                        child: const Text('Add Grantors *'),
                      ),
                      const SizedBox(
                        height: 25.0,
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
                          const SizedBox(
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

  getGrantorDetails(BuildContext context, AgriViewModel model, int index) {
    if (index == -1) {
      model.resetBankVariables(); // Add this function to reset variables
    } else {
      model.setValuesTograntorVaribles(index);
    }
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (BuildContext context,
                void Function(void Function()) setState) {
              return AlertDialog(
                title: const Text('Add Grantors'),
                content: SizedBox(
                  height: getHeight(context) / 6,
                  child: fullScreenLoader(
                    child: Form(
                      key: model.bankformKey,
                      child: Column(
                        children: [
                          Expanded(
                            child: Autocomplete<String>(
                              key: Key(index == -1
                                  ? ""
                                  : model.grantor[index].village ?? ""),
                              initialValue: TextEditingValue(
                                  text: index == -1
                                      ? ""
                                      : model.grantor[index].village ?? ""),
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<String>.empty();
                                }
                                return model.villageList
                                    .map((route) => route.name ?? "")
                                    .toList()
                                    .where((route) => route
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase()));
                              },
                              onSelected: (String routeName) {
                                // Find the corresponding route object
                                final routeData = model.villageList.firstWhere(
                                    (route) => route.name == routeName);
                                model.setSelectedgrantorvillage(
                                    routeData.name); // Pass the route
                              },
                              fieldViewBuilder: (BuildContext context,
                                  TextEditingController textEditingController,
                                  FocusNode focusNode,
                                  VoidCallback onFieldSubmitted) {
                                return TextFormField(
                                  // key: Key(model.farmerData.village ?? ""),
                                  // initialValue: model.farmerData.village,
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  decoration: const InputDecoration(
                                    labelText: 'Surety Village',
                                  ),
                                  onChanged: (String value) {},
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
                                      constraints:
                                          const BoxConstraints(maxHeight: 200),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: options.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
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
                          Expanded(
                            child: Autocomplete<String>(
                              key: Key(index == -1
                                  ? ""
                                  : model.grantor[index].suretyCode ?? ""),
                              initialValue: TextEditingValue(
                                  text: index == -1
                                      ? ""
                                      : model.grantor[index]
                                              .suretyExistingCode ??
                                          ""),
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<String>.empty();
                                }
                                final searchText =
                                    textEditingValue.text.toLowerCase();
                                return model.farmerList
                                    .where((grower) =>
                                        (grower.supplierName
                                                ?.toLowerCase()
                                                .contains(searchText) ??
                                            false) ||
                                        (grower.existingSupplierCode
                                                ?.toLowerCase()
                                                .contains(searchText) ??
                                            false))
                                    .map((grower) => grower.supplierName ?? "")
                                    .toList();
                              },
                              onSelected: (String routeName) {
                                // Find the corresponding route object
                                final bankData = model.farmerList.firstWhere(
                                    (bank) => bank.supplierName == routeName);
                                model.setSelectedgrantor(
                                    bankData.name); // Pass the route
                              },
                              fieldViewBuilder: (BuildContext context,
                                  TextEditingController textEditingController,
                                  FocusNode focusNode,
                                  VoidCallback onFieldSubmitted) {
                                return TextFormField(
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  decoration: const InputDecoration(
                                    labelText: 'Surety Name',
                                  ),
                                  onChanged: (String value) {},
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
                                      constraints:
                                          const BoxConstraints(maxHeight: 200),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: options.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final String option =
                                              options.elementAt(index);
                                          final routeData = model.farmerList
                                              .firstWhere((route) =>
                                                  route.supplierName == option);
                                          return GestureDetector(
                                            onTap: () {
                                              onSelected(option);
                                            },
                                            child: ListTile(
                                              title: Text(option),
                                              subtitle: Text(routeData
                                                  .existingSupplierCode!),
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
                          // Expanded(
                          //   child: TextFormField(
                          //     controller:
                          //         TextEditingController(text: model.suretyname),
                          //     decoration: const InputDecoration(
                          //       labelText: 'Surety Name',
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    loader: model.isBusy,
                    context: context,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      model.validateForm(context, index);
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            });
          },
        );
      },
    );
  }

  getAgricaultureDetails(BuildContext context, AgriViewModel model, int index) {
    if (index == -1) {
      model.resetAgriVariables(); // Add this function to reset variables
    } else {
      model.setValuesToAgriVaribles(index);
    }
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (BuildContext context,
                void Function(void Function()) setState) {
              return AlertDialog(
                title: const Text('Add Agricultural Development'),
                content: SizedBox(
                  height: getHeight(context) / 6,
                  child: fullScreenLoader(
                    child: Form(
                      key: model.agriformKey,
                      child: Column(
                        children: [
                          Expanded(
                            child: Autocomplete<String>(
                              key: Key(index == -1
                                  ? ""
                                  : model.agricultureDevelopmentItem[index]
                                          .itemCode ??
                                      ""),
                              initialValue: TextEditingValue(
                                  text: index == -1
                                      ? ""
                                      : model.agricultureDevelopmentItem[index]
                                              .itemCode ??
                                          ""),
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<String>.empty();
                                }
                                final searchText =
                                    textEditingValue.text.toLowerCase();
                                return model.fertilizerItemList
                                    .where((grower) =>
                                        (grower.itemName
                                                ?.toLowerCase()
                                                .contains(searchText) ??
                                            false) ||
                                        (grower.itemCode
                                                ?.toLowerCase()
                                                .contains(searchText) ??
                                            false))
                                    .map((grower) => grower.itemName ?? "")
                                    .toList();
                              },
                              onSelected: (String routeName) {
                                // Find the corresponding route object
                                final bankData = model.itemList.firstWhere(
                                    (bank) => bank.itemName == routeName);
                                model.setSelectedAgri(
                                    bankData.itemCode); // Pass the route
                              },
                              fieldViewBuilder: (BuildContext context,
                                  TextEditingController textEditingController,
                                  FocusNode focusNode,
                                  VoidCallback onFieldSubmitted) {
                                return TextFormField(
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  decoration: const InputDecoration(
                                    labelText: 'Item Name',
                                  ),
                                  onChanged: (String value) {},
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some Item';
                                    }
                                    return null;
                                  },
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
                                      constraints:
                                          const BoxConstraints(maxHeight: 200),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: options.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final String option =
                                              options.elementAt(index);
                                          final routeData = model.itemList
                                              .firstWhere((route) =>
                                                  route.itemName == option);
                                          return GestureDetector(
                                            onTap: () {
                                              onSelected(option);
                                            },
                                            child: ListTile(
                                              title: Text(option),
                                              subtitle: Text(routeData.itemCode
                                                  .toString()),
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
                          // Expanded(
                          //   child: TextFormField(
                          //     keyboardType: TextInputType.number,
                          //     controller: model
                          //         .totalController, // Use the controller here
                          //     decoration: const InputDecoration(
                          //       labelText: 'Total',
                          //     ),
                          //     onChanged: (newValue) {
                          //       double? parsedValue =
                          //           double.tryParse(newValue) ?? 0;
                          //       model.setSelectedtotal(parsedValue);
                          //     },
                          //     validator: (value) {
                          //       if (value == null || value.isEmpty) {
                          //         return 'Please enter some Total';
                          //       }
                          //       return null;
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    loader: model.isBusy,
                    context: context,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      model.validateAgriForm(context, index);
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            });
          },
        );
      },
    );
  }

  getAgricaultureDetails2(
      BuildContext context, AgriViewModel model, int index) {
    if (index == -1) {
      model.resetAgriVariables2(); // Add this function to reset variables
    } else {
      model.setValuesToAgriVaribles2(index);
    }
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (BuildContext context,
                void Function(void Function()) setState) {
              return AlertDialog(
                title: const Text('Add Agricultural Development'),
                content: SizedBox(
                  height: getHeight(context) / 5,
                  child: fullScreenLoader(
                    child: Form(
                      key: model.agriformKey,
                      child: Column(
                        children: [
                          Expanded(
                            child: Autocomplete<String>(
                              key: Key(index == -1
                                  ? ""
                                  : model.agricultureDevelopmentItem2[index]
                                          .itemCode ??
                                      ""),
                              initialValue: TextEditingValue(
                                  text: index == -1
                                      ? ""
                                      : model.agricultureDevelopmentItem2[index]
                                              .itemCode ??
                                          ""),
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<String>.empty();
                                }
                                final searchText =
                                    textEditingValue.text.toLowerCase();
                                return model.itemList
                                    .where((grower) =>
                                        (grower.itemName
                                                ?.toLowerCase()
                                                .contains(searchText) ??
                                            false) ||
                                        (grower.itemCode
                                                ?.toLowerCase()
                                                .contains(searchText) ??
                                            false))
                                    .map((grower) => grower.itemName ?? "")
                                    .toList();
                              },
                              onSelected: (String routeName) {
                                // Find the corresponding route object
                                final bankData = model.itemList.firstWhere(
                                    (bank) => bank.itemName == routeName);
                                model.setSelectedAgri2(
                                    bankData.itemCode); // Pass the route
                              },
                              fieldViewBuilder: (BuildContext context,
                                  TextEditingController textEditingController,
                                  FocusNode focusNode,
                                  VoidCallback onFieldSubmitted) {
                                return TextFormField(
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  decoration: const InputDecoration(
                                    labelText: 'Item Name',
                                  ),
                                  onChanged: (String value) {},
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some Item';
                                    }
                                    return null;
                                  },
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
                                      constraints:
                                          const BoxConstraints(maxHeight: 200),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: options.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final String option =
                                              options.elementAt(index);
                                          final routeData = model.itemList
                                              .firstWhere((route) =>
                                                  route.itemName == option);
                                          return GestureDetector(
                                            onTap: () {
                                              onSelected(option);
                                            },
                                            child: ListTile(
                                              title: AutoSizeText(option),
                                              subtitle: Text(routeData.itemCode
                                                  .toString()),
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
                            height: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: model.totalController2,
                              // Use the controller here
                              decoration: const InputDecoration(
                                labelText: 'Quantity',
                              ),
                              onChanged: (newValue) {
                                double? parsedValue =
                                    double.tryParse(newValue) ?? 0;
                                model.setSelectedtotal(parsedValue);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some Quantity';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    loader: model.isBusy,
                    context: context,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      model.validateAgriForm2(context, index);
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            });
          },
        );
      },
    );
  }
}
