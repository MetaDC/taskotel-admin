import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/core/theme/app_text_styles.dart';
import 'package:taskoteladmin/core/widget/tabel_widgets.dart';
import 'package:taskoteladmin/core/widget/responsive_widget.dart';
import 'package:taskoteladmin/features/transactions/domain/entity/transactions_model.dart';
import 'package:taskoteladmin/features/transactions/presentation/cubit/hotel_transaction_cubit.dart';

const double mobileMinSize = 768;
const double desktopMinSize = 1024;

class HotelTransactionsView extends StatefulWidget {
  final String hotelId;
  final String hotelName;

  const HotelTransactionsView({
    super.key,
    required this.hotelId,
    required this.hotelName,
  });

  @override
  State<HotelTransactionsView> createState() => _HotelTransactionsViewState();
}

class _HotelTransactionsViewState extends State<HotelTransactionsView> {
  @override
  void initState() {
    super.initState();
    context.read<HotelTransactionCubit>().initialize(widget.hotelId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HotelTransactionCubit, HotelTransactionState>(
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
  Widget _buildDesktopLayout(HotelTransactionState state, double width) {
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
          _buildSearchAndFilter(state, width),
          const SizedBox(height: 16),
          Row(
            children: [Expanded(child: _buildTransactionsList(state, width))],
          ),
          if (state.totalPages > 1) ...[
            const SizedBox(height: 16),
            _buildPagination(state, width),
          ],
        ],
      ),
    );
  }

  // Tablet Layout (768-1024px)
  Widget _buildTabletLayout(HotelTransactionState state, double width) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          _buildSearchAndFilter(state, width),
          const SizedBox(height: 16),
          Row(
            children: [Expanded(child: _buildTransactionsList(state, width))],
          ),
          if (state.totalPages > 1) ...[
            const SizedBox(height: 16),
            _buildPagination(state, width),
          ],
        ],
      ),
    );
  }

  // Mobile Layout (<768px)
  Widget _buildMobileLayout(HotelTransactionState state, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(state),
        const SizedBox(height: 12),
        _buildSearchAndFilter(state, width),
        const SizedBox(height: 12),
        _buildTransactionsList(state, width),
        if (state.totalPages > 1) ...[
          const SizedBox(height: 12),
          _buildPagination(state, width),
        ],
      ],
    );
  }

  Widget _buildHeader(HotelTransactionState state) {
    return Row(
      children: [
        const Icon(
          CupertinoIcons.building_2_fill,
          color: AppColors.primary,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hotel Transaction History",
                style: AppTextStyles.dialogHeading,
              ),
              Text(
                "Transactions for ${widget.hotelName} (${state.totalTransactions} total)",
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

  Widget _buildSearchAndFilter(HotelTransactionState state, double width) {
    final isMobile = width < mobileMinSize;
    final isTablet = width >= mobileMinSize && width < desktopMinSize;

    if (isMobile) {
      return Column(
        children: [
          SizedBox(
            height: 43,
            child: TextField(
              onChanged: (value) {
                context.read<HotelTransactionCubit>().searchTransactions(value);
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
                hintStyle: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.slateGray,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 43,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.blueGreyBorder),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: state.statusFilter,
                isExpanded: true,
                hint: Text(
                  "All Status",
                  style: GoogleFonts.inter(fontSize: 14),
                ),
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
                    child: Text(
                      "Failed",
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
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
                    context.read<HotelTransactionCubit>().filterByStatus(value);
                  }
                },
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 43,
            child: TextField(
              onChanged: (value) {
                context.read<HotelTransactionCubit>().searchTransactions(value);
              },
              decoration: InputDecoration(
                hintText: isTablet ? "Search..." : "Search transactions...",
                prefixIcon: const Icon(CupertinoIcons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.blueGreyBorder),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.slateGray,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 43,
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
                  context.read<HotelTransactionCubit>().filterByStatus(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsList(HotelTransactionState state, double width) {
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
                  context.read<HotelTransactionCubit>().initialize(
                    widget.hotelId,
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
                    : "No transactions found for this hotel",
                style: GoogleFonts.inter(color: AppColors.slateGray),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final isMobile = width < mobileMinSize;

    if (isMobile) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemCount: state.transactions.length,
        itemBuilder: (context, index) {
          return _buildMobileTransactionCard(state.transactions[index]);
        },
      );
    }

    return Column(
      children: [
        _buildTableHeader(width),
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
            return _buildTransactionRow(state.transactions[index], width);
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
            transaction.email,
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
            child: Text("Client", style: AppTextStyles.tabelHeader),
          ),
          if (!isTablet)
            Expanded(child: Text("Plan", style: AppTextStyles.tabelHeader)),
          Expanded(child: Text("Amount", style: AppTextStyles.tabelHeader)),
          Expanded(child: Text("Status", style: AppTextStyles.tabelHeader)),
          if (!isTablet)
            Expanded(child: Text("Payment", style: AppTextStyles.tabelHeader)),
          Expanded(child: Text("Date", style: AppTextStyles.tabelHeader)),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(TransactionModel transaction, double width) {
    final isTablet = width >= mobileMinSize && width < desktopMinSize;

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.clientName,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  transaction.email,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.slateGray,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
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
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Row(children: [_buildStatusBadge(transaction.status)]),
          ),
          if (!isTablet)
            Expanded(
              child: Text(
                transaction.paymentMethod.toUpperCase(),
                style: GoogleFonts.inter(fontSize: 13),
              ),
            ),
          Expanded(
            child: Text(
              DateFormat('MMM dd, yyyy').format(transaction.createdAt),
              style: GoogleFonts.inter(fontSize: 13),
            ),
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

  Widget _buildPagination(HotelTransactionState state, double width) {
    final isMobile = width < 600;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: isMobile
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: state.currentPage > 1
                          ? () => context
                                .read<HotelTransactionCubit>()
                                .goToPage(state.currentPage - 1)
                          : null,
                      icon: const Icon(CupertinoIcons.chevron_left),
                    ),
                    Text(
                      "Page ${state.currentPage} of ${state.totalPages}",
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                    IconButton(
                      onPressed: state.currentPage < state.totalPages
                          ? () => context
                                .read<HotelTransactionCubit>()
                                .goToPage(state.currentPage + 1)
                          : null,
                      icon: const Icon(CupertinoIcons.chevron_right),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  alignment: WrapAlignment.center,
                  children: _buildPageNumbers(state),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(CupertinoIcons.chevron_left),
                  onPressed: state.currentPage > 1
                      ? () => context.read<HotelTransactionCubit>().goToPage(
                          state.currentPage - 1,
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                ..._buildPageNumbers(state).map(
                  (widget) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: widget,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(CupertinoIcons.chevron_right),
                  onPressed: state.currentPage < state.totalPages
                      ? () => context.read<HotelTransactionCubit>().goToPage(
                          state.currentPage + 1,
                        )
                      : null,
                ),
              ],
            ),
    );
  }

  List<Widget> _buildPageNumbers(HotelTransactionState state) {
    return List.generate(state.totalPages > 5 ? 5 : state.totalPages, (index) {
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
        onTap: () => context.read<HotelTransactionCubit>().goToPage(pageNumber),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
    });
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:taskoteladmin/core/theme/app_colors.dart';
// import 'package:taskoteladmin/core/theme/app_text_styles.dart';
// import 'package:taskoteladmin/core/widget/tabel_widgets.dart';
// import 'package:taskoteladmin/features/transactions/domain/entity/transactions_model.dart';
// import 'package:taskoteladmin/features/transactions/presentation/cubit/hotel_transaction_cubit.dart';

// class HotelTransactionsView extends StatefulWidget {
//   final String hotelId;
//   final String hotelName;

//   const HotelTransactionsView({
//     super.key,
//     required this.hotelId,
//     required this.hotelName,
//   });

//   @override
//   State<HotelTransactionsView> createState() => _HotelTransactionsViewState();
// }

// class _HotelTransactionsViewState extends State<HotelTransactionsView> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<HotelTransactionCubit>().initialize(widget.hotelId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HotelTransactionCubit, HotelTransactionState>(
//       builder: (context, state) {
//         return Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: AppColors.blueGreyBorder),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeader(state),
//               const SizedBox(height: 16),
//               _buildSearchAndFilter(state),
//               const SizedBox(height: 16),
//               Row(children: [Expanded(child: _buildTransactionsList(state))]),
//               if (state.totalPages > 1) ...[
//                 const SizedBox(height: 16),
//                 _buildPagination(state),
//               ],
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildHeader(HotelTransactionState state) {
//     return Row(
//       children: [
//         const Icon(
//           CupertinoIcons.building_2_fill,
//           color: AppColors.primary,
//           size: 24,
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Hotel Transaction History",
//                 style: AppTextStyles.dialogHeading,
//               ),
//               Text(
//                 "Transactions for ${widget.hotelName} (${state.totalTransactions} total)",
//                 style: AppTextStyles.dialogSubheading,
//               ),
//             ],
//           ),
//         ),
//         if (state.isLoading)
//           const SizedBox(
//             height: 20,
//             width: 20,
//             child: CircularProgressIndicator(strokeWidth: 2),
//           ),
//       ],
//     );
//   }

//   Widget _buildSearchAndFilter(HotelTransactionState state) {
//     return Row(
//       children: [
//         Expanded(
//           flex: 2,
//           child: TextField(
//             onChanged: (value) {
//               context.read<HotelTransactionCubit>().searchTransactions(value);
//             },
//             decoration: InputDecoration(
//               hintText: "Search transactions...",
//               prefixIcon: const Icon(CupertinoIcons.search, size: 20),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: const BorderSide(color: AppColors.blueGreyBorder),
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 12,
//                 vertical: 8,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             border: Border.all(color: AppColors.blueGreyBorder),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: state.statusFilter,
//               hint: Text("All Status", style: GoogleFonts.inter(fontSize: 14)),
//               items: [
//                 DropdownMenuItem(
//                   value: 'all',
//                   child: Text(
//                     "All Status",
//                     style: GoogleFonts.inter(fontSize: 14),
//                   ),
//                 ),
//                 DropdownMenuItem(
//                   value: 'success',
//                   child: Text(
//                     "Success",
//                     style: GoogleFonts.inter(fontSize: 14),
//                   ),
//                 ),
//                 DropdownMenuItem(
//                   value: 'failed',
//                   child: Text("Failed", style: GoogleFonts.inter(fontSize: 14)),
//                 ),
//                 DropdownMenuItem(
//                   value: 'pending',
//                   child: Text(
//                     "Pending",
//                     style: GoogleFonts.inter(fontSize: 14),
//                   ),
//                 ),
//               ],
//               onChanged: (value) {
//                 if (value != null) {
//                   context.read<HotelTransactionCubit>().filterByStatus(value);
//                 }
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTransactionsList(HotelTransactionState state) {
//     if (state.isLoading && state.transactions.isEmpty) {
//       return const Center(
//         child: Padding(
//           padding: EdgeInsets.all(40),
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     if (state.errorMessage != null) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(40),
//           child: Column(
//             children: [
//               const Icon(
//                 CupertinoIcons.exclamationmark_triangle,
//                 size: 48,
//                 color: Colors.red,
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 state.errorMessage!,
//                 style: GoogleFonts.inter(color: Colors.red),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   context.read<HotelTransactionCubit>().initialize(
//                     widget.hotelId,
//                   );
//                 },
//                 child: const Text("Retry"),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     if (state.transactions.isEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(40),
//           child: Column(
//             children: [
//               const Icon(
//                 CupertinoIcons.doc_text,
//                 size: 48,
//                 color: AppColors.slateGray,
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 state.searchQuery.isNotEmpty
//                     ? "No transactions found matching '${state.searchQuery}'"
//                     : "No transactions found for this hotel",
//                 style: GoogleFonts.inter(color: AppColors.slateGray),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Column(
//       children: [
//         _buildTableHeader(),
//         const SizedBox(height: 8),
//         const Divider(color: AppColors.slateGray, thickness: 0.5, height: 0),
//         ListView.separated(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           separatorBuilder: (context, index) => const Divider(
//             color: AppColors.slateGray,
//             thickness: 0.1,
//             height: 0,
//           ),
//           itemCount: state.transactions.length,
//           itemBuilder: (context, index) {
//             return _buildTransactionRow(state.transactions[index]);
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildTableHeader() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text("Transaction", style: AppTextStyles.tabelHeader),
//           ),
//           Expanded(
//             flex: 2,
//             child: Text("Client", style: AppTextStyles.tabelHeader),
//           ),
//           Expanded(child: Text("Plan", style: AppTextStyles.tabelHeader)),
//           Expanded(child: Text("Amount", style: AppTextStyles.tabelHeader)),
//           Expanded(child: Text("Date", style: AppTextStyles.tabelHeader)),
//           Expanded(child: Text("Status", style: AppTextStyles.tabelHeader)),
//         ],
//       ),
//     );
//   }

//   Widget _buildTransactionRow(TransactionModel transaction) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   transaction.transactionId,
//                   style: GoogleFonts.inter(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 13,
//                   ),
//                 ),
//                 Text(
//                   transaction.paymentMethod.toUpperCase(),
//                   style: GoogleFonts.inter(
//                     fontSize: 12,
//                     color: AppColors.slateGray,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   transaction.clientName,
//                   style: GoogleFonts.inter(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w500,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 Text(
//                   transaction.email,
//                   style: GoogleFonts.inter(
//                     fontSize: 12,
//                     color: AppColors.slateGray,
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Text(
//               transaction.planName,
//               style: GoogleFonts.inter(fontSize: 13),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               "\$${transaction.amount.toStringAsFixed(2)}",
//               style: GoogleFonts.inter(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 13,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               DateFormat('MMM dd, yyyy').format(transaction.createdAt),
//               style: GoogleFonts.inter(fontSize: 13),
//             ),
//           ),
//           Expanded(
//             child: Row(children: [_buildStatusBadge(transaction.status)]),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusBadge(String status) {
//     Color backgroundColor;
//     Color textColor;

//     switch (status.toLowerCase()) {
//       case 'success':
//         backgroundColor = Colors.green.shade100;
//         textColor = Colors.green.shade700;
//         break;
//       case 'failed':
//         backgroundColor = Colors.red.shade100;
//         textColor = Colors.red.shade700;
//         break;
//       case 'pending':
//         backgroundColor = Colors.orange.shade100;
//         textColor = Colors.orange.shade700;
//         break;
//       default:
//         backgroundColor = Colors.grey.shade100;
//         textColor = Colors.grey.shade700;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         status.toUpperCase(),
//         style: GoogleFonts.inter(
//           color: textColor,
//           fontSize: 11,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }

//   Widget _buildPagination(HotelTransactionState state) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         IconButton(
//           onPressed: state.currentPage > 1
//               ? () => context.read<HotelTransactionCubit>().goToPage(
//                   state.currentPage - 1,
//                 )
//               : null,
//           icon: const Icon(CupertinoIcons.chevron_left),
//         ),
//         const SizedBox(width: 16),
//         Text(
//           "Page ${state.currentPage} of ${state.totalPages}",
//           style: GoogleFonts.inter(fontWeight: FontWeight.w500),
//         ),
//         const SizedBox(width: 16),
//         IconButton(
//           onPressed: state.currentPage < state.totalPages
//               ? () => context.read<HotelTransactionCubit>().goToPage(
//                   state.currentPage + 1,
//                 )
//               : null,
//           icon: const Icon(CupertinoIcons.chevron_right),
//         ),
//       ],
//     );
//   }
// }
