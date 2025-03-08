import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/e_service_model.dart';
import '../../global_widgets/circular_loading_widget.dart';
import 'search_services_list_item_widget.dart';

class SearchServicesListWidget extends StatelessWidget {
  final List<EService> services;

  const SearchServicesListWidget({Key? key, required this.services}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (services.isEmpty) {
        return CircularLoadingWidget(height: 300);
      } else {
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: services.length,
          // Erro 2: Uso incorreto de asteriscos (*) e função de callback
          itemBuilder: (context, index) {
            var service = services.elementAt(index);
            return SearchServicesListItemWidget(service: service);
          },
        );
      }
    });
  }
}