import 'package:dio/dio.dart';

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      // Dio errors
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return "La connexion a expiré. Veuillez vérifier votre connexion internet.";
        case DioExceptionType.sendTimeout:
          return "Le délai d'envoi des données a expiré.";
        case DioExceptionType.receiveTimeout:
          return "Le délai de réponse a expiré.";
        case DioExceptionType.badResponse:
          // HTTP specific errors
          if (error.response?.statusCode == 500) {
            return error.response?.data["message"] ??
                "Erreur serveur. Veuillez réessayer plus tard.";
          } else if (error.response?.statusCode == 401) {
            return error.response?.data["message"] ??
                "Erreur d'authentification.";
          } else if (error.response?.statusCode == 400) {
            return error.response?.data["message"] ?? "Erreur de validation.";
          } else {
            return "Erreur inattendue : ${error.response?.statusCode}";
          }
        case DioExceptionType.cancel:
          return "La requête a été annulée.";
        default:
          return "Une erreur inconnue est survenue.";
      }
    }
    return "Une erreur inconnue est survenue.";
  }
}
