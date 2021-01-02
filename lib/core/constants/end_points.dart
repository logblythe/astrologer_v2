const String baseUrl = "http://144.91.121.115:8082/api";
const String welcomeMessages = "$baseUrl/user/welcome-messages";
const String userHistory = "$baseUrl/user/previous-history";
const String register = "$baseUrl/user/register";
const String UPDATE = "$baseUrl/user/update-profile";
const String askQuestionUrl = "$baseUrl/user/ask-question";
const String fetchAstrologersUrl = "$baseUrl/user/fetch-astrologers";
const String fetchQuestionPriceUrl = "$baseUrl/user/question-price";
const String uploadProfile = "$baseUrl/user/upload-profile-picture";

const List<String> country = [
  "Select One",
  "Nepal",
  "India",
  "China",
  "Australia"
];

class QuestionStatus {
  static const NOT_DELIVERED = "NOT DELIVERED";
  static const DELIVERED = "DELIVERED";
  static const UNCLEAR = "UNCLEAR";
  static const CLEAR = "CLEAR";
}
