
class FavouriteRequest {
    final String? apartmentId;
    final String? rideId;
    final String? chefId;
    final String? serviceType;

    FavouriteRequest({
        this.apartmentId,
        this.rideId,
        this.chefId,
        this.serviceType,
    });

    FavouriteRequest copyWith({
        String? apartmentId,
        String? rideId,
        String? chefId,
        String? serviceType,
    }) => 
        FavouriteRequest(
            apartmentId: apartmentId ?? this.apartmentId,
            rideId: rideId ?? this.rideId,
            chefId: chefId ?? this.chefId,
            serviceType: serviceType ?? this.serviceType,
        );

    factory FavouriteRequest.fromJson(Map<String, dynamic> json) => FavouriteRequest(
        apartmentId: json["apartmentId"],
        rideId: json["rideId"],
        chefId: json["chefId"],
        serviceType: json["serviceType"],
    );

    Map<String, dynamic> toJson() => {
        "apartmentId": apartmentId,
        "rideId": rideId,
        "chefId": chefId,
        "serviceType": serviceType,
    };
}
