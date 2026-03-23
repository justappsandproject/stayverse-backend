import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stayverse/core/commonLibs/common_libs.dart';
import 'package:stayverse/core/util/app/debouncer.dart';
import 'package:stayverse/feature/wallet/controller/bank_controller.dart';
import 'package:stayverse/feature/wallet/model/data/bank_response.dart';
import 'package:stayverse/shared/buttons.dart';
import 'package:stayverse/shared/empty_state_view.dart';
import 'package:stayverse/shared/item_view.dart';
import 'package:stayverse/shared/line.dart';
import 'package:stayverse/shared/shrimmer/list_loader.dart';

class BankSelectionBottomSheet extends ConsumerStatefulWidget {
  static const route = '/BankSelectionBottomSheet';

  final ValueChanged<Bank>? onChooseBank;

  const BankSelectionBottomSheet({super.key, this.onChooseBank});

  @override
  ConsumerState<BankSelectionBottomSheet> createState() =>
      _BankSelectionBottomSheetState();

  static Future<Bank?> show(
    BuildContext context,
    ValueChanged<Bank> onChooseBank,
  ) {
    return showModalBottomSheet<Bank?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BankSelectionBottomSheet(
          onChooseBank: (value) {
            onChooseBank(value);
          },
        );
      },
    );
  }
}

class _BankSelectionBottomSheetState
    extends ConsumerState<BankSelectionBottomSheet> {
  final debounce =
      DebouncerService(interval: const Duration(milliseconds: 300));
  @override
  void initState() {
    Future.microtask(() {
      ref.read(bankController.notifier).resetFilterdList();
      ref.read(bankController.notifier).getBanks();
    });
    super.initState();
  }

  @override
  void dispose() {
    debounce.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        height: 0.87.sh,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                AppBtn.basic(
                    onPressed: () {
                      $navigate.back();
                    },
                    semanticLabel: '',
                    child: const Icon(
                      CupertinoIcons.clear,
                      color: Colors.black,
                    )),
                Expanded(
                  child: Center(
                    child: Text(
                      'Select Bank',
                      style: $styles.text.caption.copyWith(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                      ),
                    ).paddingOnly(right: 24),
                  ),
                ),
              ],
            ),
            const Gap(20),
            TextFormField(
              onChanged: (keyword) {
                debounce.call(() {
                  ref.read(bankController.notifier).searchFilter(keyword);
                }, false);
              },
              style: $styles.text.title1.copyWith(
                color: Colors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: 'Search Bank Name',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Flexible(
              child: ItemView(
                emptyState: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    EmptyStateView(
                      message: 'No Bank found',
                    ),
                    Gap(20)
                  ],
                ),
                itemViewBuilder: (context, Widget? child, List<Bank> items) {
                  return ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 10),
                    itemBuilder: (BuildContext context, int index) {
                      return Banks(
                        data: items[index],
                        onpressed: () {
                          widget.onChooseBank?.call(items[index]);
                          $navigate.back();
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return HorizontalLine(
                        height: 20,
                        thickness: 1,
                        color: Colors.black.withOpacity(
                          0.1,
                        ),
                      );
                    },
                    itemCount: items.length,
                  );
                },
                loader: const ListLoader(
                  itemLength: 10,
                ),
                items: ref.watch(bankController
                    .select((value) => value.getFilteredBanks.toList())),
                isAdsLoading:
                    ref.watch(bankController.select((value) => value.isBusy)),
              ),
            ),
            const Gap(20),
          ],
        ).paddingSymmetric(h: 16),
      ),
    );
  }
}

class Banks extends StatelessWidget {
  final Bank? data;
  final VoidCallback onpressed;
  const Banks({super.key, this.data, required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white.withOpacity(0.9),
        radius: 20.0,
        child: Center(
          child: Text(
            (data?.name ?? "---")
                .split(" ")
                .first
                .substring(0, 2)
                .toUpperCase(),
            style: $styles.text.caption.copyWith(
              fontSize: 15.0,
              color: Colors.black.withOpacity(0.5),
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      title: Text(data?.name ?? "---",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: $styles.text.caption.copyWith(
            fontSize: 15.0,
            color: Colors.black,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w400,
          )),
      subtitle: Text(data?.slug ?? "---",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: $styles.text.caption.copyWith(
            fontSize: 12,
            color: Colors.black,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w300,
          )),
      onTap: () {
        onpressed.call();
      },
    );
  }
}
