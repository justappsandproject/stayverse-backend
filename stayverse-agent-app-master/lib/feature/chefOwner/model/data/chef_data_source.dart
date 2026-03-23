import 'package:stayvers_agent/feature/chefOwner/model/data/add_certification.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/add_experience_request.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/chef_profile_request.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/chef_proposal_request.dart';
import 'package:stayvers_agent/feature/chefOwner/model/data/featured_request.dart';

abstract class ChefDataSource<T> {
  Future<T?> createChefProfile(ChefProfileRequest request);
  Future<T?> addExperience(ExperienceRequest expRequest);
  Future<T?> addCertification(CertificationRequest certRequest);
  Future<T?> getChefProfile(String chefId);
  Future<T?> createFeatured(FeaturedRequest request);
  Future<T?> getChefStatus();
  Future<T?> createChefProposal(String id, ChefProposalRequest request);
  Future<T?> updateChefProfile(ChefProfileRequest request);
  Future<T?> deleteExperience(String id);
  Future<T?> deleteCertification(String id);
  Future<T?> deleteFeatured(String id);
}