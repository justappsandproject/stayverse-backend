import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChefProfileShimmer extends StatelessWidget {
  const ChefProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeaderShimmer(),
            SizedBox(height: 17),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AboutSectionShimmer(),
                  CulinarySpecialtiesShimmer(),
                  ExperienceSectionShimmer(),
                  SizedBox(height: 24),
                  FeaturedSectionShimmer(),
                  SizedBox(height: 24),
                  LicenseSectionShimmer(),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerContainer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerContainer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade400,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.6),
          borderRadius: borderRadius ?? BorderRadius.circular(5),
        ),
      ),
    );
  }
}

class ProfileHeaderShimmer extends StatelessWidget {
  const ProfileHeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.06),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Cover Image Placeholder
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade200,
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  ),
                  // Profile Picture Placeholder
                  const Positioned(
                    left: 16,
                    bottom: -45,
                    child: ShimmerContainer(
                      width: 90,
                      height: 90,
                      borderRadius: BorderRadius.all(Radius.circular(45)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 65),
              const Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerContainer(width: 150, height: 16),
                        ShimmerContainer(width: 24, height: 24),
                      ],
                    ),
                    SizedBox(height: 4),
                    ShimmerContainer(width: 250, height: 10),
                    SizedBox(height: 6),
                    ShimmerContainer(width: 180, height: 8),
                    SizedBox(height: 6),
                    ShimmerContainer(width: 100, height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AboutSectionShimmer extends StatelessWidget {
  const AboutSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerContainer(width: 80, height: 16),
        const SizedBox(height: 8),
        Column(
          children: List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: ShimmerContainer(
                width: MediaQuery.of(context).size.width - 32,
                height: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ShimmerContainer(
          width: MediaQuery.of(context).size.width,
          height: 1,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class CulinarySpecialtiesShimmer extends StatelessWidget {
  const CulinarySpecialtiesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerContainer(width: 160, height: 16),
        const SizedBox(height: 12),
        Column(
          children: List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ShimmerContainer(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 7),
        ShimmerContainer(
          width: MediaQuery.of(context).size.width - 32,
          height: 40,
          borderRadius: BorderRadius.circular(8),
        ),
        const SizedBox(height: 12),
        ShimmerContainer(
          width: MediaQuery.of(context).size.width,
          height: 1,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class ExperienceSectionShimmer extends StatelessWidget {
  const ExperienceSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerContainer(width: 100, height: 16),
            ShimmerContainer(width: 60, height: 16),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          children: List.generate(
            2,
            (index) => const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: ExperienceCardShimmer(),
            ),
          ),
        ),
      ],
    );
  }
}

class ExperienceCardShimmer extends StatelessWidget {
  const ExperienceCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerContainer(width: 180, height: 16),
        SizedBox(height: 6),
        ShimmerContainer(width: 120, height: 14),
        SizedBox(height: 6),
        ShimmerContainer(width: 150, height: 12),
      ],
    );
  }
}

class FeaturedSectionShimmer extends StatelessWidget {
  const FeaturedSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerContainer(width: 80, height: 16),
            ShimmerContainer(width: 30, height: 30),
          ],
        ),
        const SizedBox(height: 24),
        ShimmerContainer(
          width: MediaQuery.of(context).size.width - 32,
          height: 200,
          borderRadius: BorderRadius.circular(10),
        ),
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShimmerContainer(width: 6, height: 6, borderRadius: BorderRadius.all(Radius.circular(3))),
            SizedBox(width: 4),
            ShimmerContainer(width: 6, height: 6, borderRadius: BorderRadius.all(Radius.circular(3))),
            SizedBox(width: 4),
            ShimmerContainer(width: 6, height: 6, borderRadius: BorderRadius.all(Radius.circular(3))),
          ],
        ),
        const SizedBox(height: 19),
        ShimmerContainer(
          width: MediaQuery.of(context).size.width,
          height: 1,
        ),
      ],
    );
  }
}

class LicenseSectionShimmer extends StatelessWidget {
  const LicenseSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerContainer(width: 180, height: 16),
            ShimmerContainer(width: 60, height: 16),
          ],
        ),
        const SizedBox(height: 14),
        Column(
          children: List.generate(
            2,
            (index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LicenseCardShimmer(),
                const SizedBox(height: 24),
                ShimmerContainer(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class LicenseCardShimmer extends StatelessWidget {
  const LicenseCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerContainer(width: 180, height: 16),
        SizedBox(height: 8),
        ShimmerContainer(width: 150, height: 14),
        SizedBox(height: 8),
        ShimmerContainer(width: 100, height: 12),
      ],
    );
  }
}