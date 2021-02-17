import PromiseParamAndId from './promiseParamAndId';
export default class DdbToEsHelper {
    private ElasticSearch;
    constructor();
    createIndexIfNotExist(indexName: string): Promise<void>;
    private generateFullId;
    getDeleteRecordPromiseParam(image: any): PromiseParamAndId;
    getUpsertRecordPromiseParam(newImage: any): PromiseParamAndId | null;
    isBinaryResource(image: any): boolean;
    logAndExecutePromises(promiseParamAndIds: PromiseParamAndId[]): Promise<void>;
}
