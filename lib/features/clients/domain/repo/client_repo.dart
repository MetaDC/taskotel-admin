import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';

/// Abstract repository interface for client operations
/// Defines the contract for client data operations with pagination support
abstract class ClientRepo {
  /// Fetch clients with pagination and status filtering
  ///
  /// [limit] - Maximum number of clients to fetch per page
  /// [startAfterDoc] - Document snapshot to start pagination after (for next page)
  /// [clientStatuses] - List of client statuses to filter by
  /// Returns a [PaginatedClientResult] containing clients and pagination info
  Future<PaginatedClientResult> fetchClients({
    required int limit,
    DocumentSnapshot? startAfterDoc,
    required List<String> clientStatuses,
  });

  /// Fetch clients with pagination using timestamp-based pagination (alternative approach)
  ///
  /// [limit] - Maximum number of clients to fetch per page
  /// [startAfter] - Timestamp to start pagination after
  /// [clientStatus] - Single client status to filter by
  /// Returns list of clients matching the criteria
  Future<List<ClientModel>> fetchClientsByTimestamp({
    required int limit,
    DateTime? startAfter,
    required String clientStatus,
  });

  /// Fetch a single client by their ID
  ///
  /// [clientId] - The unique identifier of the client
  /// Returns the client model if found, throws exception if not found
  Future<ClientModel> fetchClientById(String clientId);

  /// Get total count of clients matching specific statuses
  ///
  /// [clientStatuses] - List of statuses to count
  /// Returns the total count of matching clients
  Future<int> getClientsCount({required List<String> clientStatuses});

  /// Get total count of clients with a single status (for backward compatibility)
  ///
  /// [clientStatus] - Single status to count
  /// Returns the total count of matching clients
  Future<int> getClientCountByStatus({required String clientStatus});
}

/// Data class to hold paginated client results with metadata
/// Used by the repository to return both data and pagination information
class PaginatedClientResult {
  /// List of clients fetched for this page
  final List<ClientModel> clients;

  /// Last document snapshot for next page pagination
  final DocumentSnapshot? lastDocument;

  /// Whether there are more pages available
  final bool hasMore;

  /// Total count of clients (optional, for calculating total pages)
  final int? totalCount;

  const PaginatedClientResult({
    required this.clients,
    this.lastDocument,
    required this.hasMore,
    this.totalCount,
  });

  /// Helper to check if this is an empty result
  bool get isEmpty => clients.isEmpty;

  /// Helper to get the number of clients in this page
  int get pageSize => clients.length;

  /// Factory constructor for empty results
  factory PaginatedClientResult.empty() {
    return const PaginatedClientResult(
      clients: [],
      lastDocument: null,
      hasMore: false,
      totalCount: 0,
    );
  }
}
