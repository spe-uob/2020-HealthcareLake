import DynamoDB from 'aws-sdk/clients/dynamodb';
import { BatchRequest, TransactionRequest, BundleResponse, Bundle } from 'fhir-works-on-aws-interface';
export declare class DynamoDbBundleService implements Bundle {
    private readonly MAX_TRANSACTION_SIZE;
    private readonly ELAPSED_TIME_WARNING_MESSAGE;
    private dynamoDbHelper;
    private dynamoDb;
    private maxExecutionTimeMs;
    private static readonly dynamoDbMaxBatchSize;
    constructor(dynamoDb: DynamoDB, maxExecutionTimeMs?: number);
    batch(request: BatchRequest): Promise<BundleResponse>;
    transaction(request: TransactionRequest): Promise<BundleResponse>;
    private lockItems;
    private unlockItems;
    private rollbackItems;
    private generateFullId;
    private removeLocksFromArray;
    private stageItems;
    private getElapsedTime;
}
