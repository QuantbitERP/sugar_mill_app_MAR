import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:sugar_mill_app/constants.dart';
import 'package:sugar_mill_app/views/farmer_screens/list_farmers_view/list_farmers_model.dart';
import 'package:sugar_mill_app/views/farmer_screens/qr_scanner.dart';
import 'package:sugar_mill_app/widgets/full_screen_loader.dart';
import '../../../widgets/error_widget.dart';

class ListFarmersScreen extends StatelessWidget {
  const ListFarmersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ListFarmersModel>.reactive(
      viewModelBuilder: () => ListFarmersModel(),
      onViewModelReady: (model) => model.initialise(context),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const AutoSizeText('Farmer List'),
          actions: [
           IconButton(onPressed: (){Navigator.push(
             context,
             MaterialPageRoute(
               builder: (context) => const QRCodeScanner(
               ),
             ),
           );}, icon: const Icon(Icons.qr_code))
          ],
        ),
        body:   shimmerListView(
          child: RefreshIndicator(
            onRefresh: model.refresh,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      height: 100,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              // controller: model.villageController,
                              onChanged: (value) {
                                model.villageController.text = value;
                                model.filterListByNameAndVillage(village: value);
                              },
                              decoration: const InputDecoration(
                                labelText: ' Village',

                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          SizedBox(
                            width: getWidth(context) / 1.6,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    onChanged: (value) {
                                      model.nameController.text = value;
                                      model.filterListByNameAndVillage(
                                          name: value);
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Name',
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                SizedBox(
                                  width: getWidth(context) / 4,
                                  child: TextField(
                                    // controller: model.villageController,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      model.villageController.text = value;
                                      model.filterList(
                                          value, "existing_supplier_code");
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Vendor Code',

                                      // prefixIcon: Icon(Icons.search),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),
                model.filteredList.isNotEmpty
                    ? Expanded(
                        child: ListView.separated(
                          itemCount: model.filteredList.length,
                          itemBuilder: (context, index) {

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                  // gradient: const LinearGradient(
                                  //   colors: [Colors.white54, Colors.white],
                                  //   begin: Alignment.topLeft,
                                  //   end: Alignment.bottomRight,
                                  // ),
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
                                    model.onRowClick(context, model.filteredList[index]);
                                  },
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Top Row (Supplier name and code)
                                      Text(
                                        model.filteredList[index].supplierName?.toUpperCase() ?? "",
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        model.filteredList[index].existingSupplierCode ?? '',
                                        style: TextStyle(
                                          color: model.getColorForStatus(model.filteredList[index].workflowState.toString()),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0,
                                        ),
                                      ),
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
                                                model.filteredList[index].village ?? "N/A",
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
                                                model.filteredList[index].circleOffice ?? "N/A",
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
                                          color: model.getColorForStatus(model.filteredList[index].workflowState ?? ''),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                                        child: AutoSizeText(
                                          model.filteredList[index].workflowState ?? '',
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
