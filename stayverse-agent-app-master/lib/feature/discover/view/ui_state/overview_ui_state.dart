import 'package:stayvers_agent/feature/discover/model/data/overview_response.dart';

class OverviewUiState {
  OverviewUiState({
    this.isLoading = false,
    this.data,
  });
  
  final bool isLoading;
  final OverviewData? data;
  
  OverviewUiState copyWith({
    bool? isLoading,
    OverviewData? data,
  }) {
    return OverviewUiState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
    );
  }
}