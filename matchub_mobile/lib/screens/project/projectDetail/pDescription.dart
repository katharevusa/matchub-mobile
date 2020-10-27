import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:matchub_mobile/helpers/extensions.dart';
import 'package:readmore/readmore.dart';

import '../../../sizeconfig.dart';
import '../../../style.dart';

class PDescription extends StatelessWidget {
  Project project;
  PDescription(this.project);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: 0.5 * SizeConfig.heightMultiplier,
              horizontal: 8.0 * SizeConfig.widthMultiplier),
          child: ReadMoreText(
            project.projectDescription + project.projectDescription +"\nStatus: ${project.projStatus.capitalize} \n",
            trimLines: 3,
            style: TextStyle(
              height: 1.6,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.justify,
            colorClickableText: kSecondaryColor,
            trimMode: TrimMode.Line,
            trimCollapsedText: '...Show more',
            trimExpandedText: 'show less',
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 4),
                padding: const EdgeInsets.all(10),
                width: 20 * SizeConfig.widthMultiplier,
                height: 20 * SizeConfig.widthMultiplier,
                decoration: BoxDecoration(
                    color: AppTheme.project6,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Text("Start",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    Text("${DateFormat('dd MMM').format(project.startDate)}",
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                    Text("${DateFormat('yyyy').format(project.startDate)}",
                        style: TextStyle(fontSize: 12, color: Colors.white)),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.all(10),
                width: 20 * SizeConfig.widthMultiplier,
                height: 20 * SizeConfig.widthMultiplier,
                decoration: BoxDecoration(
                    color: AppTheme.project4,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Text("End",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                    Text("${DateFormat('dd MMM').format(project.endDate)}",
                        style: TextStyle(fontSize: 14, color: Colors.white)),
                    Text("${DateFormat('yyyy').format(project.endDate)}",
                        style: TextStyle(fontSize: 12, color: Colors.white)),
                  ],
                ),
              )
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
              //   child: Container(
              //     height: 30,
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10.0),
              //       color: AppTheme.project4,
              //     ),
              //     child: Center(
              //       child: Text(
              //           "Start Date: ${DateFormat('dd MMM yyyy ').format(project.startDate)}",
              //           style: TextStyle(fontSize: 15, color: Colors.white)),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
              //   child: Container(
              //     height: 30,
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10.0),
              //       color: AppTheme.project5,
              //     ),
              //     child: Center(
              //       child: Text(
              //           "End Date: ${DateFormat('dd-MMM-yyyy ').format(project.endDate)}",
              //           style: TextStyle(fontSize: 15, color: Colors.white)),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  buildEndDate() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("END:", style: TextStyle(color: Colors.white, fontSize: 20)),
          Text(DateFormat('EEEE').format(project.endDate),
              style: TextStyle(color: Colors.white)),
          Text(
              '${project.endDate.day} ' +
                  DateFormat('MMM').format(project.endDate) +
                  ' ${project.endDate.year}',
              style: TextStyle(color: Colors.white, fontSize: 15)),
          Text('${project.endDate.hour}:${project.endDate.minute}',
              style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  buildStartDate() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "START:",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(DateFormat('EEEE').format(project.startDate),
              style: TextStyle(color: Colors.white)),
          Text(
              '${project.startDate.day} ' +
                  DateFormat('MMM').format(project.startDate) +
                  ' ${project.startDate.year}',
              style: TextStyle(color: Colors.white, fontSize: 15)),
          Text('${project.startDate.hour}:${project.startDate.minute}',
              style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
