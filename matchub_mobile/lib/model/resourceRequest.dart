import 'package:matchub_mobile/model/approverEnum.dart';
import 'package:matchub_mobile/model/project.dart';

class ResourceRequest {
  DateTime requestCreationTime;
  RequestStatusEnum requestStatusEnum;
  int requestorId;
  String message;
  ApproverEnum approverEnum;
  Project project;

  ResourceRequest(this.requestCreationTime, this.requestStatusEnum,
      this.requestorId, this.message, this.approverEnum);
}

enum RequestStatusEnum { ON_HOLD, REJECTED, ACCEPTED }
