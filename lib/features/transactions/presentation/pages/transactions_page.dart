import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/widget/page_header.dart';
import 'package:taskoteladmin/core/widget/stats_card.dart';
import 'package:taskoteladmin/core/widget/tabel_widgets.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/features/transactions/domain/entity/transactions_model.dart';
import 'package:taskoteladmin/features/transactions/presentation/cubit/transaction_cubit.dart';

const double mobileMinSize = 768;
const double desktopMinSize = 1024;

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
        return ResponsiveCustomBuilder(
          mobileBuilder: (width) => _buildMobileLayout(state, width),
          tabletBuilder: (width) => _buildTabletLayout(state, width),
          desktopBuilder: (width) => _buildDesktopLayout(state, width),
        );
      },
    );
  }

  // Desktop Layout (>1024px)
  Widget _buildDesktopLayout(TransactionState state, double width) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          children: [
            _buildHeader(state),
            const SizedBox(height: 30),
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
                  _buildFiltersAndSearch(state, width),
                  const SizedBox(height: 20),
                  _buildTransactionsList(state, width),
                  const SizedBox(height: 20),
                  if (state.totalPages > 1 &&
                      context
                          .read<TransactionCubit>()
                          .state
                          .searchQuery
                          .isEmpty)
                    _buildPagination(state),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Tablet Layout (768-1024px)
  Widget _buildTabletLayout(TransactionState state, double width) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            _buildHeader(state),
            const SizedBox(height: 20),
            _buildAnalyticsCards(state),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.blueGreyBorder),
              ),
              child: Column(
                children: [
                  _buildFiltersAndSearch(state, width),
                  const SizedBox(height: 16),
                  _buildTransactionsList(state, width),
                  const SizedBox(height: 16),
                  if (state.totalPages > 1 &&
                      context
                          .read<TransactionCubit>()
                          .state
                          .searchQuery
                          .isEmpty)
                    _buildPagination(state),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Mobile Layout (<768px)
  Widget _buildMobileLayout(TransactionState state, double width) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          children: [
            _buildHeader(state),
            const SizedBox(height: 16),
            _buildAnalyticsCards(state),
            const SizedBox(height: 16),
            Column(
              children: [
                _buildFiltersAndSearch(state, width),
                const SizedBox(height: 12),
                _buildTransactionsList(state, width),
                const SizedBox(height: 12),
                if (state.totalPages > 1 &&
                    context.read<TransactionCubit>().state.searchQuery.isEmpty)
                  _buildPagination(state),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
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

  Widget _buildFiltersAndSearch(TransactionState state, double width) {
    final isMobile = width < mobileMinSize;
    final isTablet = width >= mobileMinSize && width < desktopMinSize;

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Transactions", style: AppTextStyles.customContainerTitle),
          const SizedBox(height: 12),
          SizedBox(
            height: 43,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search transactions...",
                suffixIcon: state.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(CupertinoIcons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<TransactionCubit>().searchTransactions(
                            '',
                          );
                        },
                      )
                    : null,
                prefixIcon: const Icon(
                  CupertinoIcons.search,
                  color: AppColors.slateGray,
                  size: 20,
                ),
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
                hintStyle: GoogleFonts.inter(
                  color: AppColors.slateGray,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onChanged: (value) {
                context.read<TransactionCubit>().searchTransactions(value);
              },
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 43,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButton<TransactionFilter>(
              value: state.selectedFilter,
              isExpanded: true,
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
        ],
      );
    }

    return Row(
      children: [
        Text("Transactions", style: AppTextStyles.customContainerTitle),
        const Spacer(),
        SizedBox(
          width: isTablet ? 200 : 300,
          height: 43,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: isTablet
                  ? "Search..."
                  : "Search by transaction ID, name, email, amount...",
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
              hintStyle: GoogleFonts.inter(
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

  Widget _buildTransactionsList(TransactionState state, double width) {
    if (state.isLoading || state.isSearching) {
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
            Text(state.errorMessage!, style: GoogleFonts.inter(fontSize: 16)),
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
              style: GoogleFonts.inter(fontSize: 16),
            ),
          ],
        ),
      );
    }

    final isMobile = width < mobileMinSize;

    if (isMobile) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return _buildMobileTransactionCard(transactions[index]);
        },
      );
    }

    return Column(
      children: [
        const SizedBox(height: 20),
        _buildTableHeader(width),
        const SizedBox(height: 13),
        const Divider(color: AppColors.slateGray, thickness: 0.07, height: 0),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const Divider(
            color: AppColors.slateGray,
            thickness: 0.07,
            height: 0,
          ),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            return _buildTransactionRow(transactions[index], width);
          },
        ),
      ],
    );
  }

  Widget _buildMobileTransactionCard(TransactionModel transaction) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.blueGreyBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  transaction.transactionId,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _buildStatusBadge(transaction.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            transaction.clientName,
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Text(
            transaction.hotelName,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.slateGray),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xff3e85f6).withOpacity(0.1),
                  border: Border.all(
                    color: const Color(0xff3e85f6),
                    width: 0.7,
                  ),
                ),
                child: Text(
                  transaction.planName,
                  style: GoogleFonts.inter(
                    color: const Color(0xff3e85f6),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Amount",
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.slateGray,
                    ),
                  ),
                  Text(
                    "\$${transaction.amount.toStringAsFixed(2)}",
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    transaction.paymentMethod.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.slateGray,
                    ),
                  ),
                  Text(
                    DateFormat('MMM dd, yyyy').format(transaction.createdAt),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.slateGray,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(double width) {
    final isTablet = width >= mobileMinSize && width < desktopMinSize;

    return Row(
      children: [
        SizedBox(width: TableConfig.horizontalSpacing / 2),
        Expanded(
          flex: 2,
          child: Text("Transaction ID", style: AppTextStyles.tabelHeader),
        ),
        Expanded(
          flex: 2,
          child: Text("Client/Hotel", style: AppTextStyles.tabelHeader),
        ),
        if (!isTablet)
          Expanded(child: Text("Plan", style: AppTextStyles.tabelHeader)),
        Expanded(child: Text("Amount", style: AppTextStyles.tabelHeader)),
        Expanded(child: Text("Status", style: AppTextStyles.tabelHeader)),
        if (!isTablet)
          Expanded(child: Text("Payment", style: AppTextStyles.tabelHeader)),
        Expanded(child: Text("Date", style: AppTextStyles.tabelHeader)),
        SizedBox(width: TableConfig.horizontalSpacing / 2),
      ],
    );
  }

  Widget _buildTransactionRow(TransactionModel transaction, double width) {
    final isTablet = width >= mobileMinSize && width < desktopMinSize;

    return Padding(
      padding: TableConfig.rowPadding,
      child: Row(
        children: [
          SizedBox(width: TableConfig.horizontalSpacing / 2),
          Expanded(
            flex: 2,
            child: Text(
              transaction.transactionId,
              style: AppTextStyles.tableRowPrimary.copyWith(fontSize: 13.5),
            ),
          ),
          Expanded(
            flex: 2,
            child: TableTwoLineContent(
              primaryText: transaction.clientName,
              secondaryText: transaction.hotelName,
            ),
          ),
          if (!isTablet)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xff3e85f6).withOpacity(0.1),
                      border: Border.all(
                        color: const Color(0xff3e85f6),
                        width: 0.7,
                      ),
                    ),
                    child: Text(
                      transaction.planName,
                      style: GoogleFonts.inter(
                        color: const Color(0xff3e85f6),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Text(
              "\$${transaction.amount.toStringAsFixed(2)}",
              style: AppTextStyles.tableRowPrimary,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [_buildStatusBadge(transaction.status)],
            ),
          ),
          if (!isTablet)
            Expanded(
              child: Text(
                transaction.paymentMethod.toUpperCase(),
                style: AppTextStyles.tableRowRegular,
              ),
            ),
          Expanded(
            child: Text(
              DateFormat('MMM dd, yyyy').format(transaction.createdAt),
              style: AppTextStyles.tableRowDate,
            ),
          ),
          SizedBox(width: TableConfig.horizontalSpacing / 2),
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
        style: GoogleFonts.inter(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPagination(TransactionState state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: isMobile
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(CupertinoIcons.chevron_left),
                          onPressed: state.currentPage > 1
                              ? () => context
                                    .read<TransactionCubit>()
                                    .previousPage()
                              : null,
                        ),
                        Text(
                          "Page ${state.currentPage} of ${state.totalPages}",
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                        IconButton(
                          icon: const Icon(CupertinoIcons.chevron_right),
                          onPressed: state.currentPage < state.totalPages
                              ? () =>
                                    context.read<TransactionCubit>().nextPage()
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      alignment: WrapAlignment.center,
                      children: List.generate(
                        state.totalPages > 5 ? 5 : state.totalPages,
                        (index) {
                          int pageNumber;
                          if (state.totalPages <= 5) {
                            pageNumber = index + 1;
                          } else if (state.currentPage <= 3) {
                            pageNumber = index + 1;
                          } else if (state.currentPage >=
                              state.totalPages - 2) {
                            pageNumber = state.totalPages - 4 + index;
                          } else {
                            pageNumber = state.currentPage - 2 + index;
                          }

                          return InkWell(
                            onTap: () => context
                                .read<TransactionCubit>()
                                .fetchPage(pageNumber),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
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
                                style: GoogleFonts.inter(
                                  color: state.currentPage == pageNumber
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: state.currentPage == pageNumber
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(CupertinoIcons.chevron_left),
                      onPressed: state.currentPage > 1
                          ? () =>
                                context.read<TransactionCubit>().previousPage()
                          : null,
                    ),
                    const SizedBox(width: 16),
                    ...List.generate(
                      state.totalPages > 5 ? 5 : state.totalPages,
                      (index) {
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

                        return InkWell(
                          onTap: () => context
                              .read<TransactionCubit>()
                              .fetchPage(pageNumber),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
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
                              style: GoogleFonts.inter(
                                color: state.currentPage == pageNumber
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: state.currentPage == pageNumber
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(CupertinoIcons.chevron_right),
                      onPressed: state.currentPage < state.totalPages
                          ? () => context.read<TransactionCubit>().nextPage()
                          : null,
                    ),
                  ],
                ),
        );
      },
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:taskoteladmin/core/theme/app_colors.dart';
// import 'package:taskoteladmin/core/theme/app_text_styles.dart';
// import 'package:taskoteladmin/core/widget/page_header.dart';
// import 'package:taskoteladmin/core/widget/stats_card.dart';
// import 'package:taskoteladmin/core/widget/tabel_widgets.dart';
// import 'package:taskoteladmin/features/transactions/domain/entity/transactions_model.dart';
// import 'package:taskoteladmin/features/transactions/presentation/cubit/transaction_cubit.dart';

// class TransactionsPage extends StatefulWidget {
//   const TransactionsPage({super.key});

//   @override
//   State<TransactionsPage> createState() => _TransactionsPageState();
// }

// class _TransactionsPageState extends State<TransactionsPage> {
//   final TextEditingController _searchController = TextEditingController();
//   DateTime? _customStartDate;
//   DateTime? _customEndDate;

//   @override
//   void initState() {
//     super.initState();
//     context.read<TransactionCubit>().initialize();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<TransactionCubit, TransactionState>(
//       builder: (context, state) {
//         return SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
//             child: Column(
//               children: [
//                 // Header with search and filter
//                 _buildHeader(state),
//                 const SizedBox(height: 30),

//                 // Analytics Cards
//                 _buildAnalyticsCards(state),
//                 const SizedBox(height: 30),

//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: AppColors.blueGreyBorder),
//                   ),
//                   child: Column(
//                     children: [
//                       _buildFiltersAndSearch(state),

//                       const SizedBox(height: 20),

//                       _buildTransactionsList(state),
//                       const SizedBox(height: 20),

//                       //if items are more than 10 show pagination
//                       if (state.totalPages > 1 &&
//                           context
//                               .read<TransactionCubit>()
//                               .state
//                               .searchQuery
//                               .isEmpty)
//                         _buildPagination(state),
//                     ],
//                   ),
//                 ),

//                 // Filters and Search Bar
//                 const SizedBox(height: 20),

//                 // Transactions List
//                 // Expanded(child: _buildTransactionsList(state)),

//                 // Pagination
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildHeader(TransactionState state) {
//     return Row(
//       children: [
//         Expanded(
//           child: PageHeaderWithTitle(
//             heading: "Transactions",
//             subHeading: "Manage and view all transactions",
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAnalyticsCards(TransactionState state) {
//     final analytics = state.analytics ?? {};

//     return StaggeredGrid.extent(
//       maxCrossAxisExtent: 500,
//       mainAxisSpacing: 16,
//       crossAxisSpacing: 16,
//       children: [
//         StatCardIconRight(
//           icon: CupertinoIcons.money_dollar,
//           label: "Total Revenue",
//           value: "\$${(analytics['totalRevenue'] ?? 0).toStringAsFixed(2)}",
//           iconColor: Colors.green,
//         ),
//         StatCardIconRight(
//           icon: CupertinoIcons.arrow_up_arrow_down_circle,
//           label: "Successful Transactions",
//           value: "${analytics['successfulTransactions'] ?? 0}",
//           iconColor: Colors.green,
//         ),
//         StatCardIconRight(
//           icon: CupertinoIcons.money_dollar,
//           label: "Pending Payments",
//           value: "${analytics['pendingPayments'] ?? 0}",
//           iconColor: Colors.orange,
//         ),
//         StatCardIconRight(
//           icon: CupertinoIcons.calendar,
//           label: "This Month's Transactions",
//           value: "${analytics['thisMonthTransactions'] ?? 0}",
//           iconColor: Colors.blue,
//         ),
//       ],
//     );
//   }

//   Widget _buildFiltersAndSearch(TransactionState state) {
//     return Row(
//       children: [
//         Text(
//           "Transactions",
//           style: GoogleFonts.inter(fontSize: 21, fontWeight: FontWeight.w600),
//         ),
//         const Spacer(),

//         // Search Bar
//         SizedBox(
//           width: 300,
//           height: 43,

//           child: TextField(
//             controller: _searchController,
//             decoration: InputDecoration(
//               hintText: "Search by transaction ID, name, email, amount...",
//               suffixIcon: state.searchQuery.isNotEmpty
//                   ? IconButton(
//                       icon: const Icon(CupertinoIcons.clear),
//                       onPressed: () {
//                         _searchController.clear();
//                         context.read<TransactionCubit>().searchTransactions('');
//                       },
//                     )
//                   : null,
//               prefixIcon: const Icon(
//                 CupertinoIcons.search,
//                 color: AppColors.slateGray,
//                 size: 20,
//               ),
//               hoverColor: Colors.transparent,

//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: AppColors.blueGreyBorder),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: AppColors.blueGreyBorder),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: AppColors.blueGreyBorder),
//               ),

//               hintStyle: GoogleFonts.inter(
//                 color: AppColors.slateGray,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             onChanged: (value) {
//               context.read<TransactionCubit>().searchTransactions(value);
//             },
//           ),
//         ),

//         const SizedBox(width: 16),
//         // Filter Dropdown
//         Container(
//           height: 43,
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: Colors.grey[300]!),
//           ),
//           child: DropdownButton<TransactionFilter>(
//             value: state.selectedFilter,
//             underline: const SizedBox(),
//             items: const [
//               DropdownMenuItem(
//                 value: TransactionFilter.all,
//                 child: Text("All Transactions"),
//               ),
//               DropdownMenuItem(
//                 value: TransactionFilter.today,
//                 child: Text("Today"),
//               ),
//               DropdownMenuItem(
//                 value: TransactionFilter.weekly,
//                 child: Text("This Week"),
//               ),
//               DropdownMenuItem(
//                 value: TransactionFilter.monthly,
//                 child: Text("This Month"),
//               ),
//               DropdownMenuItem(
//                 value: TransactionFilter.custom,
//                 child: Text("Custom Range"),
//               ),
//             ],
//             onChanged: (filter) async {
//               if (filter == TransactionFilter.custom) {
//                 await _showDateRangePicker();
//               } else {
//                 context.read<TransactionCubit>().changeFilter(filter!);
//               }
//             },
//           ),
//         ),
//         // const SizedBox(width: 16),
//         // // Search Within Filter Switch
//         // Switch(
//         //   value: state.searchWithinFilter,
//         //   onChanged: (value) {
//         //     context.read<TransactionCubit>().toggleSearchWithinFilter(value);
//         //   },
//         // ),
//       ],
//     );
//   }

//   Future<void> _showDateRangePicker() async {
//     final DateTimeRange? picked = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//       initialDateRange: _customStartDate != null && _customEndDate != null
//           ? DateTimeRange(start: _customStartDate!, end: _customEndDate!)
//           : null,
//     );

//     if (picked != null && mounted) {
//       _customStartDate = picked.start;
//       _customEndDate = picked.end;
//       context.read<TransactionCubit>().changeFilter(
//         TransactionFilter.custom,
//         startDate: picked.start,
//         endDate: picked.end,
//       );
//     }
//   }

//   Widget _buildTransactionsList(TransactionState state) {
//     if (state.isLoading || state.isSearching) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (state.errorMessage != null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               CupertinoIcons.exclamationmark_triangle,
//               size: 64,
//               color: Colors.grey[400],
//             ),
//             const SizedBox(height: 16),
//             Text(state.errorMessage!, style: GoogleFonts.inter(fontSize: 16)),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () => context.read<TransactionCubit>().initialize(),
//               child: const Text("Retry"),
//             ),
//           ],
//         ),
//       );
//     }

//     final transactions = state.searchQuery.isNotEmpty
//         ? state.searchResults
//         : state.currentPageTransactions;

//     if (transactions.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(CupertinoIcons.doc_text, size: 64, color: Colors.grey[400]),
//             const SizedBox(height: 16),
//             Text(
//               state.searchQuery.isNotEmpty
//                   ? "No transactions found matching '${state.searchQuery}'"
//                   : "No transactions found",
//               style: GoogleFonts.inter(fontSize: 16),
//             ),
//           ],
//         ),
//       );
//     }

//     return Column(
//       children: [
//         const SizedBox(height: 20),

//         // Table Header
//         _buildTableHeader(),
//         const SizedBox(height: 13),
//         const Divider(color: AppColors.slateGray, thickness: 0.07, height: 0),
//         // Table Body
//         ListView.separated(
//           shrinkWrap: true,
//           separatorBuilder: (context, index) => const Divider(
//             color: AppColors.slateGray,
//             thickness: 0.07,
//             height: 0,
//           ),
//           itemCount: transactions.length,
//           itemBuilder: (context, index) {
//             return _buildTransactionRow(transactions[index]);
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildTableHeader() {
//     return Row(
//       children: [
//         SizedBox(width: TableConfig.horizontalSpacing / 2),

//         Expanded(
//           flex: 2,
//           child: Text("Transaction ID", style: AppTextStyles.tabelHeader),
//         ),
//         Expanded(
//           flex: 2,
//           child: Text("Client/Hotel", style: AppTextStyles.tabelHeader),
//         ),
//         Expanded(child: Text("Plan", style: AppTextStyles.tabelHeader)),
//         Expanded(child: Text("Amount", style: AppTextStyles.tabelHeader)),
//         Expanded(child: Text("Status", style: AppTextStyles.tabelHeader)),
//         Expanded(child: Text("Payment", style: AppTextStyles.tabelHeader)),
//         Expanded(child: Text("Date", style: AppTextStyles.tabelHeader)),
//         SizedBox(width: TableConfig.horizontalSpacing / 2),
//       ],
//     );
//   }

//   Widget _buildTransactionRow(TransactionModel transaction) {
//     return Padding(
//       padding: TableConfig.rowPadding,
//       child: Row(
//         children: [
//           SizedBox(width: TableConfig.horizontalSpacing / 2),

//           // Transaction ID
//           Expanded(
//             flex: 2,
//             child: Text(
//               transaction.transactionId,
//               style: AppTextStyles.tableRowPrimary.copyWith(fontSize: 13.5),
//             ),
//           ),

//           // Client/Hotel
//           Expanded(
//             flex: 2,
//             child: TableTwoLineContent(
//               primaryText: transaction.clientName,
//               secondaryText: transaction.hotelName,
//             ),
//           ),

//           // Plan
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                     color: Color(0xff3e85f6).withOpacity(0.1),
//                     border: Border.all(color: Color(0xff3e85f6), width: .7),
//                   ),
//                   child: Text(
//                     transaction.planName,
//                     style: GoogleFonts.inter(
//                       color: Color(0xff3e85f6),
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Amount
//           Expanded(
//             child: Text(
//               "\$${transaction.amount.toStringAsFixed(2)}",
//               style: AppTextStyles.tableRowPrimary,
//             ),
//           ),

//           // Status
//           Expanded(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [_buildStatusBadge(transaction.status)],
//             ),
//           ),

//           // Payment Method
//           Expanded(
//             child: Text(
//               transaction.paymentMethod.toUpperCase(),
//               style: AppTextStyles.tableRowRegular,
//             ),
//           ),

//           // Date
//           Expanded(
//             child: Text(
//               DateFormat('MMM dd, yyyy').format(transaction.createdAt),
//               style: AppTextStyles.tableRowDate,
//             ),
//           ),
//           SizedBox(width: TableConfig.horizontalSpacing / 2),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusBadge(String status) {
//     Color color;
//     switch (status.toLowerCase()) {
//       case 'success':
//         color = Colors.green;
//         break;
//       case 'failed':
//         color = Colors.red;
//         break;
//       case 'refunded':
//         color = Colors.orange;
//         break;
//       default:
//         color = Colors.grey;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color),
//       ),
//       child: Text(
//         status.toUpperCase(),
//         style: GoogleFonts.inter(
//           color: color,
//           fontSize: 10,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   Widget _buildPagination(TransactionState state) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Previous Button
//           IconButton(
//             icon: const Icon(CupertinoIcons.chevron_left),
//             onPressed: state.currentPage > 1
//                 ? () => context.read<TransactionCubit>().previousPage()
//                 : null,
//           ),

//           const SizedBox(width: 16),

//           // Page Numbers
//           ...List.generate(state.totalPages > 5 ? 5 : state.totalPages, (
//             index,
//           ) {
//             int pageNumber;
//             if (state.totalPages <= 5) {
//               pageNumber = index + 1;
//             } else if (state.currentPage <= 3) {
//               pageNumber = index + 1;
//             } else if (state.currentPage >= state.totalPages - 2) {
//               pageNumber = state.totalPages - 4 + index;
//             } else {
//               pageNumber = state.currentPage - 2 + index;
//             }

//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 4),
//               child: InkWell(
//                 onTap: () =>
//                     context.read<TransactionCubit>().fetchPage(pageNumber),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 8,
//                   ),
//                   decoration: BoxDecoration(
//                     color: state.currentPage == pageNumber
//                         ? AppColors.primary
//                         : Colors.white,
//                     borderRadius: BorderRadius.circular(4),
//                     border: Border.all(
//                       color: state.currentPage == pageNumber
//                           ? AppColors.primary
//                           : Colors.grey[300]!,
//                     ),
//                   ),
//                   child: Text(
//                     pageNumber.toString(),
//                     style: GoogleFonts.inter(
//                       color: state.currentPage == pageNumber
//                           ? Colors.white
//                           : Colors.black,
//                       fontWeight: state.currentPage == pageNumber
//                           ? FontWeight.bold
//                           : FontWeight.normal,
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }),

//           const SizedBox(width: 16),

//           // Next Button
//           IconButton(
//             icon: const Icon(CupertinoIcons.chevron_right),
//             onPressed: state.currentPage < state.totalPages
//                 ? () => context.read<TransactionCubit>().nextPage()
//                 : null,
//           ),

//           const SizedBox(width: 16),

//           // Page Info
//           Text(
//             "Page ${state.currentPage} of ${state.totalPages}",
//             style: GoogleFonts.inter(fontSize: 14),
//           ),
//         ],
//       ),
//     );
//   }
// }
