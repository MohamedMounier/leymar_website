import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:lymar_sample_project/models/resource_model.dart';
import 'package:lymar_sample_project/models/testimonial_model.dart';

class ResourcesRepository {
  Future<List<ResourceModel>> loadResources() async {
    final jsonString =
        await rootBundle.loadString('lib/data/json/resources.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((j) => ResourceModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<List<TestimonialModel>> loadTestimonials() async {
    final jsonString =
        await rootBundle.loadString('lib/data/json/testimonials.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((j) => TestimonialModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }
}
