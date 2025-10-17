import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/widget/tabel_widgets.dart';
import 'package:taskoteladmin/features/transactions/domain/entity/transactions_model.dart';
import 'package:taskoteladmin/features/transactions/presentation/cubit/client_transaction_cubit.dart';

class ClientTransactionsView extends StatefulWidget {
  final String clientId;
  final String clientName;

  const ClientTransactionsView({
    super.key,
    required this.clientId,
    required this.clientName,
  });

  @override
  State<ClientTransactionsView> createState() => _ClientTransactionsViewState();
}

class _ClientTransactionsViewState extends State<ClientTransactionsView> {
  @override
  void initState() {
    super.initState();
    context.read<ClientTransactionCubit>().initialize(widget.clientId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientTransactionCubit, ClientTransactionState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.blueGreyBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(state),
              const SizedBox(height: 16),
              _buildSearchAndFilter(state),
              const SizedBox(height: 16),
              _buildTransactionsList(state),
              if (state.totalPages > 1) ...[
                const SizedBox(height: 16),
                _buildPagination(state),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(ClientTransactionState state) {
    return Row(
      children: [
        const Icon(
          CupertinoIcons.money_dollar_circle,
          color: AppColors.primary,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Transaction History", style: AppTextStyles.dialogHeading),
              Text(
                "Transactions for ${widget.clientName} (${state.totalTransactions} total)",
                style: AppTextStyles.dialogSubheading,
              ),
            ],
          ),
        ),
        if (state.isLoading)
          const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
      ],
    );
  }

  Widget _buildSearchAndFilter(ClientTransactionState state) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            onChanged: (value) {
              context.read<ClientTransactionCubit>().searchTransactions(value);
            },
            decoration: InputDecoration(
              hintText: "Search transactions...",
              prefixIcon: const Icon(CupertinoIcons.search, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.blueGreyBorder),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.blueGreyBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: state.statusFilter,
              hint: Text("All Status", style: GoogleFonts.inter(fontSize: 14)),
              items: [
                DropdownMenuItem(
                  value: 'all',
                  child: Text(
                    "All Status",
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                ),
                DropdownMenuItem(
                  value: 'success',
                  child: Text(
                    "Success",
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                ),
                DropdownMenuItem(
                  value: 'failed',
                  child: Text("Failed", style: GoogleFonts.inter(fontSize: 14)),
                ),
                DropdownMenuItem(
                  value: 'pending',
                  child: Text(
                    "Pending",
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  context.read<ClientTransactionCubit>().filterByStatus(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsList(ClientTransactionState state) {
    if (state.isLoading && state.transactions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const Icon(
                CupertinoIcons.exclamationmark_triangle,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                state.errorMessage!,
                style: GoogleFonts.inter(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<ClientTransactionCubit>().initialize(
                    widget.clientId,
                  );
                },
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    if (state.transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const Icon(
                CupertinoIcons.doc_text,
                size: 48,
                color: AppColors.slateGray,
              ),
              const SizedBox(height: 16),
              Text(
                state.searchQuery.isNotEmpty
                    ? "No transactions found matching '${state.searchQuery}'"
                    : "No transactions found for this client",
                style: GoogleFonts.inter(color: AppColors.slateGray),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        _buildTableHeader(),
        const SizedBox(height: 8),
        const Divider(color: AppColors.slateGray, thickness: 0.5, height: 0),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const Divider(
            color: AppColors.slateGray,
            thickness: 0.1,
            height: 0,
          ),
          itemCount: state.transactions.length,
          itemBuilder: (context, index) {
            return _buildTransactionRow(state.transactions[index]);
          },
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text("Transaction", style: AppTextStyles.tabelHeader),
          ),
          Expanded(
            flex: 2,
            child: Text("Hotel", style: AppTextStyles.tabelHeader),
          ),
          Expanded(child: Text("Plan", style: AppTextStyles.tabelHeader)),
          Expanded(child: Text("Amount", style: AppTextStyles.tabelHeader)),
          Expanded(child: Text("Date", style: AppTextStyles.tabelHeader)),
          Expanded(child: Text("Status", style: AppTextStyles.tabelHeader)),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(TransactionModel transaction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.transactionId,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                Text(
                  transaction.paymentMethod.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.slateGray,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              transaction.hotelName,
              style: GoogleFonts.inter(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              transaction.planName,
              style: GoogleFonts.inter(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Text(
              "\$${transaction.amount.toStringAsFixed(2)}",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              DateFormat('MMM dd, yyyy').format(transaction.createdAt),
              style: GoogleFonts.inter(fontSize: 13),
            ),
          ),
          Expanded(
            child: Row(children: [_buildStatusBadge(transaction.status)]),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'success':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        break;
      case 'failed':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade700;
        break;
      case 'pending':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade700;
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPagination(ClientTransactionState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: state.currentPage > 1
              ? () => context.read<ClientTransactionCubit>().goToPage(
                  state.currentPage - 1,
                )
              : null,
          icon: const Icon(CupertinoIcons.chevron_left),
        ),
        const SizedBox(width: 16),
        Text(
          "Page ${state.currentPage} of ${state.totalPages}",
          style: GoogleFonts.inter(fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 16),
        IconButton(
          onPressed: state.currentPage < state.totalPages
              ? () => context.read<ClientTransactionCubit>().goToPage(
                  state.currentPage + 1,
                )
              : null,
          icon: const Icon(CupertinoIcons.chevron_right),
        ),
      ],
    );
  }
}
