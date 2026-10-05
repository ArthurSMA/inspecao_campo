import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

import '../models/inspection_model.dart';

abstract class InspectionRemoteDataSource {
  Future<List<InspectionModel>> fetchInspections();
  Future<InspectionModel> submitInspection(InspectionModel inspection);
}

class InspectionRemoteDataSourceImpl implements InspectionRemoteDataSource {
  InspectionRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<InspectionModel>> fetchInspections() async {
    final response = await _dio.get('/inspections');
    final data = response.data as List<dynamic>;
    return data
        .map((json) => InspectionModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<InspectionModel> submitInspection(InspectionModel inspection) async {
    final photoPath = inspection.photoPath;
    if (photoPath == null || photoPath.isEmpty) {
      throw StateError('A foto da inspeção é obrigatória para sincronizar.');
    }

    final formData = FormData.fromMap({
      'clientId': inspection.clientId,
      'workOrderId': inspection.workOrderId,
      'observation': inspection.observation,
      if (inspection.condition != null) 'condition': inspection.condition,
      'latitude': inspection.latitude,
      'longitude': inspection.longitude,
      'capturedAt': inspection.capturedAt.toUtc().toIso8601String(),
      'photo': await MultipartFile.fromFile(
        photoPath,
        filename: p.basename(photoPath),
      ),
    });

    final response = await _dio.post(
      '/inspections',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }

    final payload = response.data as Map<String, dynamic>;
    return InspectionModel.fromJson(payload);
  }
}
