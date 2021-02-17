import { BatchReadWriteRequest, BatchReadWriteResponse, TypeOperation, SystemOperation } from 'fhir-works-on-aws-interface';
export default class DynamoDbBundleServiceHelper {
    static generateStagingRequests(requests: BatchReadWriteRequest[], idToVersionId: Record<string, number>): {
        deleteRequests: any;
        createRequests: any;
        updateRequests: any;
        readRequests: any;
        newLocks: ItemRequest[];
        newStagingResponses: BatchReadWriteResponse[];
    };
    static generateRollbackRequests(bundleEntryResponses: BatchReadWriteResponse[]): {
        transactionRequests: any;
        itemsToRemoveFromLock: {
            id: string;
            vid: string;
            resourceType: string;
        }[];
    };
    private static generateDeleteLatestRecordAndItemToRemoveFromLock;
    static populateBundleEntryResponseWithReadResult(bundleEntryResponses: BatchReadWriteResponse[], readResult: any): BatchReadWriteResponse[];
    private static addStagingResponseAndItemsLocked;
}
export interface ItemRequest {
    id: string;
    vid?: number;
    resourceType: string;
    operation: TypeOperation | SystemOperation;
    isOriginalUpdateItem?: boolean;
}
