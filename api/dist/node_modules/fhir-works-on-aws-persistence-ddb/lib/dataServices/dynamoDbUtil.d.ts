import DOCUMENT_STATUS from './documentStatus';
export declare const DOCUMENT_STATUS_FIELD = "documentStatus";
export declare const LOCK_END_TS_FIELD = "lockEndTs";
export declare const VID_FIELD = "vid";
export declare class DynamoDbUtil {
    static cleanItem(item: any): any;
    static prepItemForDdbInsert(resource: any, id: string, vid: number, documentStatus: DOCUMENT_STATUS): any;
}
