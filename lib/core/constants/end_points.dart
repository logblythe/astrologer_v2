import 'package:flutter/material.dart';

const String baseUrl = "http://localhost:8082/api";
// const String baseUrl = "http://a6eaf9fbedd4.ngrok.io/api";
// const String baseUrl = "http://api.cosmosastrology.com/api";
const String welcomeMessages = "$baseUrl/user/welcome-messages";
const String userHistory = "$baseUrl/user/previous-history";
const String register = "$baseUrl/user/register";
const String UPDATE = "$baseUrl/user/update-profile";
const String askQuestionUrl = "$baseUrl/user/ask-question";
const String fetchAstrologersUrl = "$baseUrl/user/fetch-astrologers";
const String fetchQuestionPriceUrl = "$baseUrl/user/question-price";
const String uploadProfile = "$baseUrl/user/upload-profile-picture";
const String IPIFY_API_KEY = "at_fbaNCdRelumktbfnIs0fP6uqyxgbS";

const List<String> country = [
  "Select One",
  "Nepal",
  "India",
  "China",
  "Australia"
];

final GlobalKey<ScaffoldState> scaffoldHome = GlobalKey<ScaffoldState>();

class QuestionStatus {
  static const NOT_DELIVERED = "NOT DELIVERED";
  static const DELIVERED = "DELIVERED";
  static const UNCLEAR = "UNCLEAR";
  static const CLEAR = "CLEAR";
}
