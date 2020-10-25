import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matchub_mobile/models/index.dart';
import 'package:readmore/readmore.dart';

import '../../../sizeconfig.dart';
import '../../../style.dart';

class PDescription extends StatelessWidget {
  Project project;
  PDescription(this.project);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 30,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: AppTheme.project4,
            ),
            child: Center(
              child: Text(
                  "Start Date: ${DateFormat('dd-MMM-yyyy ').format(project.startDate)}",
                  style: TextStyle(fontSize: 15, color: Colors.white)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 30,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: AppTheme.project5,
            ),
            child: Center(
              child: Text(
                  "End Date: ${DateFormat('dd-MMM-yyyy ').format(project.endDate)}",
                  style: TextStyle(fontSize: 15, color: Colors.white)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: 0.5 * SizeConfig.heightMultiplier,
              horizontal: 8.0 * SizeConfig.widthMultiplier),
          child: ReadMoreText(
            project.projectDescription + "\n\nStatus: ${project.projStatus}\n",
            trimLines: 3,
            style: TextStyle(
              height: 1.6,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.justify,
            colorClickableText: kSecondaryColor,
            trimMode: TrimMode.Line,
            trimCollapsedText: '...Show more',
            trimExpandedText: 'show less',
          ),
        ),
      ],
    );
  }
}
