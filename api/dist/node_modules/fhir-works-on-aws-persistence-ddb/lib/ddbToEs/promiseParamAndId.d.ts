export default interface PromiseParamAndId {
    promiseParam: any;
    id: string;
    type: PromiseType;
}
export declare type PromiseType = 'delete' | 'upsert-AVAILABLE' | 'upsert-DELETED';
