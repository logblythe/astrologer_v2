const String UNCLEAR = "unclear";
const String CLEAR = "clear";
const String UNASSIGNED = "unassigned";
const String NOT_DELIVERED = "Not delivered";
const String DELIVERED = "Delivered";

const String ID = "id";
const String MESSAGE = "answer";
const String STATUS = "status";
const String SENT = "sent";
const String QUESTION_ID = "engQuestionId";
const String CREATED_AT = "createdAt";
const String DELETED_AT = "deletedAt";
const String UPDATED_AT = "updatedAt";
const String ASTROLOGER = "astrologer";
const String ASTROLOGER_URL = "astrologerUrl";

class MessageModel {
  int id;
  String message;
  bool sent;
  String status;
  int questionId;
  String error;
  int createdAt;
  int updatedAt;
  String astrologer;
  String astrologerUrl;

  MessageModel(
      {this.id,
      this.message,
      this.sent,
      this.status,
      this.questionId,
      this.error,
      this.createdAt,
      this.updatedAt,
      this.astrologer,
      this.astrologerUrl});

  MessageModel.fromJson(Map<String, dynamic> json)
      : message = json[MESSAGE],
        sent = json[SENT],
        status = json[STATUS] ?? "",
        questionId = json[QUESTION_ID],
        error = json["error"],
        astrologer = json[ASTROLOGER],
        astrologerUrl = json[ASTROLOGER_URL];

  MessageModel.fromNotification(Map<String, dynamic> json)
      : message = json[MESSAGE],
        sent = false,
        status = json[STATUS] ?? "",
        questionId = json[QUESTION_ID],
        astrologer = json[ASTROLOGER];

  Map<String, dynamic> toMapForDb() => {
        MESSAGE: message,
        SENT: sent ? 1 : 0,
        STATUS: status,
        QUESTION_ID: questionId,
        CREATED_AT: createdAt,
        ASTROLOGER: astrologer,
        ID: id,
      };

  MessageModel.fromDb(Map<String, dynamic> json)
      : id = json[ID],
        message = json[MESSAGE],
        status = json[STATUS],
        sent = json[SENT] == 1,
        questionId = json[QUESTION_ID],
        astrologer = json[ASTROLOGER],
        createdAt = json[CREATED_AT];

  @override
  String toString() {
    return toMapForDb().toString();
  }

  MessageModel.withError(String error) : error = error;
}
