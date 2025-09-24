import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskoteladmin/core/services/firebase.dart';
import 'package:taskoteladmin/core/utils/const.dart';
import 'package:taskoteladmin/features/clients/domain/entity/client_model.dart';
import 'package:taskoteladmin/features/clients/domain/repo/client_repo.dart';

/// Firebase implementation of the ClientRepo interface
/// Handles all Firestore operations for client data management
/// Supports pagination, status filtering, and client retrieval operations
class ClientFirebaseRepo extends ClientRepo {
  /// Reference to the clients collection in Firestore
  final CollectionReference<Map<String, dynamic>> clientCollectionRef =
      FBFireStore.clients;

  @override
  Future<PaginatedClientResult> fetchClients({
    required int limit,
    DocumentSnapshot? startAfterDoc,
    required List<String> clientStatuses,
  }) async {
    try {
      // Validate input parameters
      if (clientStatuses.isEmpty) {
        return PaginatedClientResult.empty();
      }

      // Build the base query with status filtering and ordering
      Query<Map<String, dynamic>> query = clientCollectionRef
          .where('status', whereIn: clientStatuses)
          .orderBy(
            'createdAt',
            descending: true,
          ) // Order by creation date (newest first)
          .limit(limit);

      // Add pagination cursor if provided
      if (startAfterDoc != null) {
        query = query.startAfterDocument(startAfterDoc);
      }

      // Execute the query
      final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

      // Convert documents to ClientModel objects
      final List<ClientModel> clients = snapshot.docs
          .map((doc) {
            try {
              return ClientModel.fromDocSnap(doc);
            } catch (e) {
              print('Error parsing client document ${doc.id}: $e');
              // Skip malformed documents and continue
              return null;
            }
          })
          .where((client) => client != null)
          .cast<ClientModel>()
          .toList();

      // Create result with pagination metadata
      return PaginatedClientResult(
        clients: clients,
        lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
        hasMore:
            snapshot.docs.length ==
            limit, // If we got full limit, assume there's more
      );
    } catch (e) {
      print('Error fetching clients with statuses $clientStatuses: $e');
      throw Exception('Failed to fetch clients: ${e.toString()}');
    }
  }

  @override
  Future<List<ClientModel>> fetchClientsByTimestamp({
    required int limit,
    DateTime? startAfter,
    required String clientStatus,
  }) async {
    try {
      // Build query with timestamp-based pagination
      Query<Map<String, dynamic>> query = clientCollectionRef
          .where('status', isEqualTo: clientStatus)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      // Add timestamp cursor if provided
      if (startAfter != null) {
        query = query.startAfter([Timestamp.fromDate(startAfter)]);
      }

      // Execute query and convert results
      final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

      return snapshot.docs
          .map((doc) {
            try {
              return ClientModel.fromDocSnap(doc);
            } catch (e) {
              print('Error parsing client document ${doc.id}: $e');
              return null;
            }
          })
          .where((client) => client != null)
          .cast<ClientModel>()
          .toList();
    } catch (e) {
      print(
        'Error fetching clients by timestamp with status $clientStatus: $e',
      );
      throw Exception('Failed to fetch clients by timestamp: ${e.toString()}');
    }
  }

  @override
  Future<ClientModel> fetchClientById(String clientId) async {
    try {
      // Validate client ID
      if (clientId.trim().isEmpty) {
        throw ArgumentError('Client ID cannot be empty');
      }

      // Fetch the document by ID
      final DocumentSnapshot<Map<String, dynamic>> doc =
          await clientCollectionRef.doc(clientId).get();

      // Check if document exists and convert to model
      if (doc.exists && doc.data() != null) {
        return ClientModel.fromSnap(doc);
      } else {
        throw Exception('Client with ID $clientId not found');
      }
    } catch (e) {
      print('Error fetching client by ID $clientId: $e');
      if (e is Exception) {
        rethrow; // Re-throw our custom exceptions
      }
      throw Exception('Failed to fetch client: ${e.toString()}');
    }
  }

  @override
  Future<int> getClientsCount({required List<String> clientStatuses}) async {
    try {
      // Validate input
      if (clientStatuses.isEmpty) {
        return 0;
      }

      // Execute count query with status filter
      final AggregateQuerySnapshot countSnapshot = await clientCollectionRef
          .where('status', whereIn: clientStatuses)
          .count()
          .get();

      return countSnapshot.count ?? 0;
    } catch (e) {
      print('Error getting clients count for statuses $clientStatuses: $e');
      throw Exception('Failed to get clients count: ${e.toString()}');
    }
  }

  @override
  Future<int> getClientCountByStatus({required String clientStatus}) async {
    try {
      // Use the multi-status method with single status for consistency
      return await getClientsCount(clientStatuses: [clientStatus]);
    } catch (e) {
      print('Error getting client count for status $clientStatus: $e');
      throw Exception('Failed to get client count: ${e.toString()}');
    }
  }

  /// Additional helper methods for common operations

  /// Fetch active clients (status: active or trial)
  ///
  /// [limit] - Maximum number of clients to fetch
  /// [startAfterDoc] - Document to start pagination after
  /// Returns paginated result of active clients
  Future<PaginatedClientResult> fetchActiveClients({
    required int limit,
    DocumentSnapshot? startAfterDoc,
  }) async {
    return fetchClients(
      limit: limit,
      startAfterDoc: startAfterDoc,
      clientStatuses: [ClientStatus.active, ClientStatus.trial],
    );
  }

  /// Fetch lost clients (status: inactive, suspended, or churned)
  ///
  /// [limit] - Maximum number of clients to fetch
  /// [startAfterDoc] - Document to start pagination after
  /// Returns paginated result of lost clients
  Future<PaginatedClientResult> fetchLostClients({
    required int limit,
    DocumentSnapshot? startAfterDoc,
  }) async {
    return fetchClients(
      limit: limit,
      startAfterDoc: startAfterDoc,
      clientStatuses: [
        ClientStatus.inactive,
        ClientStatus.suspended,
        ClientStatus.churned,
      ],
    );
  }

  /// Get count of active clients
  /// Returns total number of active and trial clients
  Future<int> getActiveClientsCount() async {
    return getClientsCount(
      clientStatuses: [ClientStatus.active, ClientStatus.trial],
    );
  }

  /// Get count of lost clients
  /// Returns total number of inactive, suspended, and churned clients
  Future<int> getLostClientsCount() async {
    return getClientsCount(
      clientStatuses: [
        ClientStatus.inactive,
        ClientStatus.suspended,
        ClientStatus.churned,
      ],
    );
  }
}

/*
Key features of this implementation:

1. **Multiple Pagination Approaches**:
   - Document-based pagination (recommended for Firestore)
   - Timestamp-based pagination (alternative approach)

2. **Robust Error Handling**:
   - Input validation
   - Graceful handling of malformed documents
   - Detailed error messages with context

3. **Status Filtering**:
   - Support for multiple status filtering
   - Convenience methods for active/lost clients
   - Backward compatibility with single status

4. **Performance Optimizations**:
   - Ordered queries for consistent pagination
   - Efficient count queries using Firestore aggregation
   - Null safety throughout

5. **Flexibility**:
   - Both interface methods implemented
   - Helper methods for common use cases
   - Easy to extend for additional functionality

Usage Example:
```dart
final repo = ClientFirebaseRepo();

// Fetch first page of active clients
final result = await repo.fetchActiveClients(limit: 10);

// Fetch next page using last document
final nextResult = await repo.fetchActiveClients(
  limit: 10,
  startAfterDoc: result.lastDocument,
);
```
*/
