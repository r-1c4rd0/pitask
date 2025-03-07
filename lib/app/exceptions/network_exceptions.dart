import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as _get;
import '../routes/app_routes.dart';

abstract class NetworkExceptions {
  static String handleResponse(Response response) {
    // Recupera o status code ou define 0 se for nulo.
    final int statusCode = response.statusCode ?? 0;
    switch (statusCode) {
      case 400:
      case 401:
      case 403:
      // Redireciona para a tela de login.
        _get.Get.offAllNamed(Routes.LOGIN);
        return "Unauthorized Request";
      case 404:
        return "Not found";
      case 409:
        return "Error due to a conflict";
      case 408:
        return "Connection request timeout";
      case 500:
        return "Internal Server Error";
      case 503:
        return "Service unavailable";
      default:
        return "Received invalid status code";
    }
  }

  static String getDioException(error) {
    if (error is Exception) {
      try {
        String errorMessage = "";
        if (error is DioError) {
          // Utiliza somente DioExceptionType (DioErrorType foi substituído)
          switch (error.type) {
            case DioExceptionType.cancel:
              errorMessage = "Request Cancelled";
              break;
            case DioExceptionType.connectionTimeout:
              errorMessage = "Connection request timeout";
              break;
            case DioExceptionType.unknown:
              errorMessage = "No internet connection";
              break;
            case DioExceptionType.receiveTimeout:
              errorMessage = "Send timeout in connection with API server";
              break;
            case DioExceptionType.badResponse:
            // Verifica se a resposta não é nula antes de chamar handleResponse
              errorMessage = handleResponse(error.response!);
              break;
            case DioExceptionType.sendTimeout:
              errorMessage = "Send timeout in connection with API server";
              break;
            case DioExceptionType.badCertificate:
            // TODO: Implementar o tratamento para certificados inválidos.
              throw UnimplementedError();
            case DioExceptionType.connectionError:
            // TODO: Implementar o tratamento para erros de conexão.
              throw UnimplementedError();
          }
        } else if (error is SocketException) {
          errorMessage = "No internet connection";
        } else {
          errorMessage = "Unexpected error occurred";
        }
        return errorMessage;
      } on FormatException {
        return "Unexpected error occurred";
      } catch (_) {
        return "Unexpected error occurred";
      }
    } else {
      if (error.toString().contains("is not a subtype of")) {
        return "Unable to process the data";
      } else {
        return "Unexpected error occurred";
      }
    }
  }
}
