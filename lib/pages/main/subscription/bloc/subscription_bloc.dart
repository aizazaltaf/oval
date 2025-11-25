import 'dart:io';

import 'package:admin/constants.dart';
import 'package:admin/models/data/payment_methods_model.dart';
import 'package:admin/models/data/transaction_history_model.dart';
import 'package:admin/models/data/user_data.dart';
import 'package:admin/models/states/api_state.dart';
import 'package:admin/pages/main/subscription/bloc/subscription_state.dart';
import 'package:admin/services/api_service.dart';
import 'package:admin/utils/cubit_utils.dart';
import 'package:admin/utils/dio.dart';
import 'package:admin/utils/toast_utils.dart';
import 'package:admin/widgets/cubit.dart';
import 'package:admin/widgets/pdf_downloader.dart';
import 'package:built_collection/built_collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

part 'subscription_bloc.bloc.g.dart';

@BlocGen()
class SubscriptionBloc
    extends BVCubit<SubscriptionState, SubscriptionStateBuilder>
    with _SubscriptionBlocMixin {
  SubscriptionBloc() : super(SubscriptionState());

  factory SubscriptionBloc.of(final BuildContext context) =>
      BlocProvider.of<SubscriptionBloc>(context);

  Future<void> callPaymentMethods() {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.paymentMethodsApi,
      updateApiState: (final b, final apiState) =>
          b.paymentMethodsApi.replace(apiState),
      callApi: () async {
        final BuiltList<PaymentMethodsModel> paymentMethodsList =
            await apiService.getPaymentMethodsList();
        updatePaymentMethodsList(paymentMethodsList);
      },
    );
  }

  Future<void> callOnRefreshPaymentMethods() async {
    final BuiltList<PaymentMethodsModel> paymentMethodsList =
        await apiService.getPaymentMethodsList();
    updatePaymentMethodsList(paymentMethodsList);
  }

  Future<void> callMakeDefaultPaymentMethod(int paymentId) {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.defaultPaymentMethodApi,
      updateApiState: (final b, final apiState) =>
          b.defaultPaymentMethodApi.replace(apiState),
      callApi: () async {
        await apiService.makeDefaultPaymentMethod(paymentId);
        await callPaymentMethods();
      },
    );
  }

  Future<void> callDeletePaymentMethod(int paymentId) {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.deletePaymentMethodApi,
      updateApiState: (final b, final apiState) =>
          b.deletePaymentMethodApi.replace(apiState),
      callApi: () async {
        await apiService.deletePaymentMethod(paymentId);
        await callPaymentMethods();
      },
    );
  }

  Future<void> callTransactionHistory() {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.transactionHistoryApi,
      updateApiState: (final b, final apiState) =>
          b.transactionHistoryApi.replace(apiState),
      callApi: () async {
        final BuiltList<TransactionHistoryModel> transactionHistoryList =
            await apiService.getPaymentTransactions(state.transactionFilter);
        updateTransactionHistoryList(transactionHistoryList);
      },
    );
  }

  Future<void> callDownloadInvoice({
    required BuildContext context,
    required String subscriptionId,
  }) {
    return CubitUtils.makeApiCall(
      cubit: this,
      apiState: state.downloadInvoiceApi,
      updateApiState: (final b, final apiState) =>
          b.downloadInvoiceApi.replace(apiState),
      callApi: () async {
        updateDownloadingPdf(true);
        final url = await apiService.getPaymentTransactionInvoiceUrl(
          subscriptionId,
        );
        await downloadInvoice(url);
        Constants.dismissLoader();
        updateDownloadingPdf(false);
      },
      onError: (e) {
        Constants.dismissLoader();
        updateDownloadingPdf(false);
      },
    );
  }

  Future<bool> checkStoragePermission() async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt >= 33) {
        // Android 13+ (API 33+), request MANAGE_EXTERNAL_STORAGE
        status = await Permission.manageExternalStorage.request();
      } else {
        // Below Android 13, request legacy storage
        status = await Permission.storage.request();
      }
    } else {
      //  iOS, request (WILL BE DONE BY HAMZA)
      status = await Permission.storage.request();
    }

    // Return true if granted or limited (iOS limited photo library)
    return status.isGranted || status.isLimited;
  }

  Future<void> downloadInvoice(String url) async {
    try {
      // ✅ Request storage permission (Android)
      // updateDownloadingPdf(true);

      final status = await checkStoragePermission();

      if (status) {
        Directory? dir;
        if (Platform.isAndroid) {
          dir = await getExternalStorageDirectory();
          dir = Directory('/storage/emulated/0/Download');
        } else {
          dir = await getApplicationDocumentsDirectory();
        }
        final String filename =
            "transaction_invoice_${DateTime.now().millisecondsSinceEpoch}.pdf";
        final String filePath = "${dir.path}/$filename";

        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }

        if (Platform.isAndroid) {
          await PdfDownloader().downloadAndNotify(
            url: url,
            savePath: filePath,
            filename: filename,
          );
        } else if (Platform.isIOS) {
          await dio.download(url, filePath);
          final params = ShareParams(
            files: [XFile(filePath)],
          );
          await SharePlus.instance.share(params);
          await PdfDownloader().downloadAndNotify(
            url: url,
            savePath: filePath,
            filename: filename,
          );
        }
        // ToastUtils.successToast("Invoice has been successfully downloaded");

        logger.fine("✅ Downloaded to: $filePath");

        updateDownloadingPdf(false);
      } else {
        logger.fine("Storage permission denied");
        updateDownloadingPdf(false);
        ToastUtils.errorToast("Invoice has not been downloaded");
        return;
      }
    } catch (e) {
      updateDownloadingPdf(false);

      ToastUtils.errorToast("Invoice has not been downloaded");

      logger.fine("❌ Download failed: $e");
    }
  }
}
