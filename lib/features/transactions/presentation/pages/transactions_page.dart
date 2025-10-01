import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/widget/page_header.dart';
import 'package:taskoteladmin/core/widget/stats_card.dart';
import 'package:taskoteladmin/core/widget/tabel_widgets.dart';
import 'package:taskoteladmin/features/transactions/domain/entity/transactions_model.dart';
import 'package:taskoteladmin/features/transactions/presentation/cubit/transaction_cubit.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final TextEditingController _searchController = TextEditingController();
  DateTime? _customStartDate;
  DateTime? _customEndDate;

  @override
  void initState() {
    super.initState();
    context.read<TransactionCubit>().initialize();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              children: [
                // Header with search and filter
                _buildHeader(state),
                const SizedBox(height: 30),

                // Analytics Cards
                _buildAnalyticsCards(state),
                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.blueGreyBorder),
                  ),
                  child: Column(
                    children: [
                      _buildFiltersAndSearch(state),

                      const SizedBox(height: 20),

                      _buildTransactionsList(state),
                      if (!state.isSearching && state.searchQuery.isEmpty)
                        _buildPagination(state),
                    ],
                  ),
                ),

                // Filters and Search Bar
                const SizedBox(height: 20),

                // Transactions List
                // Expanded(child: _buildTransactionsList(state)),

                // Pagination
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(TransactionState state) {
    return Row(
      children: [
        Expanded(
          child: PageHeaderWithTitle(
            heading: "Transactions",
            subHeading: "Manage and view all transactions",
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsCards(TransactionState state) {
    final analytics = state.analytics ?? {};

    return StaggeredGrid.extent(
      maxCrossAxisExtent: 500,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        StatCardIconRight(
          icon: CupertinoIcons.money_dollar,
          label: "Total Revenue",
          value: "\$${(analytics['totalRevenue'] ?? 0).toStringAsFixed(2)}",
          iconColor: Colors.green,
        ),
        StatCardIconRight(
          icon: CupertinoIcons.arrow_up_arrow_down_circle,
          label: "Successful Transactions",
          value: "${analytics['successfulTransactions'] ?? 0}",
          iconColor: Colors.green,
        ),
        StatCardIconRight(
          icon: CupertinoIcons.money_dollar,
          label: "Pending Payments",
          value: "${analytics['pendingPayments'] ?? 0}",
          iconColor: Colors.orange,
        ),
        StatCardIconRight(
          icon: CupertinoIcons.calendar,
          label: "This Month's Transactions",
          value: "${analytics['thisMonthTransactions'] ?? 0}",
          iconColor: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildFiltersAndSearch(TransactionState state) {
    return Row(
      children: [
        const Text(
          "Transactions",
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
        ),
        const Spacer(),

        // Search Bar
        SizedBox(
          width: 300,
          height: 43,

          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search by transaction ID, name, email, amount...",
              suffixIcon: state.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(CupertinoIcons.clear),
                      onPressed: () {
                        _searchController.clear();
                        context.read<TransactionCubit>().searchTransactions('');
                      },
                    )
                  : null,
              prefixIcon: const Icon(
                CupertinoIcons.search,
                color: AppColors.slateGray,
                size: 20,
              ),
              hoverColor: Colors.transparent,

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: AppColors.blueGreyBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: AppColors.blueGreyBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: AppColors.blueGreyBorder),
              ),

              hintStyle: TextStyle(
                color: AppColors.slateGray,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            onChanged: (value) {
              context.read<TransactionCubit>().searchTransactions(value);
            },
          ),
        ),

        const SizedBox(width: 16),
        // Filter Dropdown
        Container(
          height: 43,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButton<TransactionFilter>(
            value: state.selectedFilter,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(
                value: TransactionFilter.all,
                child: Text("All Transactions"),
              ),
              DropdownMenuItem(
                value: TransactionFilter.today,
                child: Text("Today"),
              ),
              DropdownMenuItem(
                value: TransactionFilter.weekly,
                child: Text("This Week"),
              ),
              DropdownMenuItem(
                value: TransactionFilter.monthly,
                child: Text("This Month"),
              ),
              DropdownMenuItem(
                value: TransactionFilter.custom,
                child: Text("Custom Range"),
              ),
            ],
            onChanged: (filter) async {
              if (filter == TransactionFilter.custom) {
                await _showDateRangePicker();
              } else {
                context.read<TransactionCubit>().changeFilter(filter!);
              }
            },
          ),
        ),
        const SizedBox(width: 16),
        // Search Within Filter Switch
        Switch(
          value: state.searchWithinFilter,
          onChanged: (value) {
            context.read<TransactionCubit>().toggleSearchWithinFilter(value);
          },
        ),
      ],
    );
  }

  Future<void> _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _customStartDate != null && _customEndDate != null
          ? DateTimeRange(start: _customStartDate!, end: _customEndDate!)
          : null,
    );

    if (picked != null && mounted) {
      _customStartDate = picked.start;
      _customEndDate = picked.end;
      context.read<TransactionCubit>().changeFilter(
        TransactionFilter.custom,
        startDate: picked.start,
        endDate: picked.end,
      );
    }
  }

  Widget _buildTransactionsList(TransactionState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.exclamationmark_triangle,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(state.errorMessage!, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<TransactionCubit>().initialize(),
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    final transactions = state.searchQuery.isNotEmpty
        ? state.searchResults
        : state.currentPageTransactions;

    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.doc_text, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              state.searchQuery.isNotEmpty
                  ? "No transactions found matching '${state.searchQuery}'"
                  : "No transactions found",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Table Header
        _buildTableHeader(),
        const SizedBox(height: 13),
        const Divider(color: AppColors.slateGray, thickness: 0.07, height: 0),
        // Table Body
        ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) => const Divider(
            color: AppColors.slateGray,
            thickness: 0.07,
            height: 0,
          ),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            return _buildTransactionRow(transactions[index]);
          },
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text("Transaction ID", style: AppTextStyles.tabelHeader),
        ),
        Expanded(
          flex: 2,
          child: Text("Client/Hotel", style: AppTextStyles.tabelHeader),
        ),
        Expanded(child: Text("Plan", style: AppTextStyles.tabelHeader)),
        Expanded(child: Text("Amount", style: AppTextStyles.tabelHeader)),
        Expanded(child: Text("Status", style: AppTextStyles.tabelHeader)),
        Expanded(child: Text("Payment", style: AppTextStyles.tabelHeader)),
        Expanded(child: Text("Date", style: AppTextStyles.tabelHeader)),
      ],
    );
  }

  Widget _buildTransactionRow(TransactionModel transaction) {
    return Container(
      padding: TableConfig.transactionRowPadding,
      decoration: TableConfig.getRowBorder(),
      child: Row(
        children: [
          // Transaction ID
          Expanded(
            flex: 2,
            child: Text(
              transaction.transactionId,
              style: AppTextStyles.tableRowPrimary,
            ),
          ),

          // Client/Hotel
          Expanded(
            flex: 2,
            child: TableTwoLineContent(
              primaryText: transaction.clientName,
              secondaryText: transaction.hotelName,
            ),
          ),

          // Plan
          Expanded(
            child: Text(
              transaction.planName,
              style: AppTextStyles.tableRowRegular,
            ),
          ),

          // Amount
          Expanded(
            child: Text(
              "\$${transaction.amount.toStringAsFixed(2)}",
              style: AppTextStyles.tableRowPrimary,
            ),
          ),

          // Status
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [_buildStatusBadge(transaction.status)],
            ),
          ),

          // Payment Method
          Expanded(
            child: Text(
              transaction.paymentMethod.toUpperCase(),
              style: AppTextStyles.tableRowRegular,
            ),
          ),

          // Date
          Expanded(
            child: Text(
              DateFormat('MMM dd, yyyy').format(transaction.createdAt),
              style: AppTextStyles.tableRowDate,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'success':
        color = Colors.green;
        break;
      case 'failed':
        color = Colors.red;
        break;
      case 'refunded':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPagination(TransactionState state) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous Button
          IconButton(
            icon: const Icon(CupertinoIcons.chevron_left),
            onPressed: state.currentPage > 1
                ? () => context.read<TransactionCubit>().previousPage()
                : null,
          ),

          const SizedBox(width: 16),

          // Page Numbers
          ...List.generate(state.totalPages > 5 ? 5 : state.totalPages, (
            index,
          ) {
            int pageNumber;
            if (state.totalPages <= 5) {
              pageNumber = index + 1;
            } else if (state.currentPage <= 3) {
              pageNumber = index + 1;
            } else if (state.currentPage >= state.totalPages - 2) {
              pageNumber = state.totalPages - 4 + index;
            } else {
              pageNumber = state.currentPage - 2 + index;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                onTap: () =>
                    context.read<TransactionCubit>().fetchPage(pageNumber),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: state.currentPage == pageNumber
                        ? AppColors.primary
                        : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: state.currentPage == pageNumber
                          ? AppColors.primary
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Text(
                    pageNumber.toString(),
                    style: TextStyle(
                      color: state.currentPage == pageNumber
                          ? Colors.white
                          : Colors.black,
                      fontWeight: state.currentPage == pageNumber
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }),

          const SizedBox(width: 16),

          // Next Button
          IconButton(
            icon: const Icon(CupertinoIcons.chevron_right),
            onPressed: state.currentPage < state.totalPages
                ? () => context.read<TransactionCubit>().nextPage()
                : null,
          ),

          const SizedBox(width: 16),

          // Page Info
          Text(
            "Page ${state.currentPage} of ${state.totalPages}",
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
