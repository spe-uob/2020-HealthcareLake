import { BatchReadWriteRequest, Persistence, TypeOperation } from 'fhir-works-on-aws-interface';
export default class BundleParser {
    static SELF_CONTAINED_REFERENCE: string;
    /**
     * Parse a Bundle request to make sure the request is valid, and update the internal references
     * of the Bundle entries to be valid and internally consistent
     * @param bundleRequestJson - the full Bundle json request as a JS object
     * @param dataService - the Persistence object that will be used to verify references to resource on the server
     * @param serverUrl - the base URL of thhe server
     * @return BatchReadWriteRequests that can be executed to write the Bundle entries to the Database
     */
    static parseResource(bundleRequestJson: any, dataService: Persistence, serverUrl: string): Promise<BatchReadWriteRequest[]>;
    /**
     * Given a Bundle entry, parse that entry to see what operation that entry wants to perform. Throw an error
     * if the FHIR server does not support that operation for Bundles
     * @param entry - The Bundle entry we want to get the operation for
     * @return TypeOperation
     * @throws Error
     */
    private static getOperation;
    /**
     * Given a Bundle, get all of the resources and the operations on those resources for that Bundle
     * Eg. Patient: ['create', 'update'], means there were at least two entries in the bundle. There was at least
     * one entry requesting to create Patient, and at least one entry requesting to update Patient.
     * @param bundleRequestJson - the full Bundle json request as a JS object
     * @return Record with resourceType as the key, and an array of TypeOperations as the value
     */
    static getResourceTypeOperationsInBundle(bundleRequestJson: any): Record<string, TypeOperation[]>;
    /**
     * Check that all references within the Bundle is valid and update them as required
     * If entry X in the bundle has a reference to entry Y within the bundle,
     * update the reference to use the server assigned id for entry Y
     * @param requests - entries from the Bundle that has been parsed into BatchReadWriteRequests
     * @param dataService - the Persistence object that will be used to verify references to resource on the server
     * @param serverUrl - the base URL of thhe server
     * return BatchReadWriteRequests that can be executed to write the Bundle entries to the Database
     */
    private static updateReferenceRequestsIfNecessary;
    /**
     * Check that references are valid, and update the id of internal references
     * @param orderedBundleEntriesId - Ordered list of ids from the Bundle entries
     * @param idToRequestWithRef - Record with request Id as the key and a request that has a reference as the value
     * @param fullUrlToRequest - Record with full url of the request as key and the request as the value
     * @param allRequests - all requests in the Bundle that does not have a full Url
     * @param serverUrl - the base URL of thhe server
     * @param dataService - the Persistence object that will be used to verify references to resource on the server
     * @return BatchReadWriteRequests that can be executed to write the Bundle entries to the Database
     */
    private static checkReferences;
    /**
     * Check whether the reference in a request refers to a contained resource, and if it does, check
     * whether the contained resource exist
     * @param requestWithRef - A request that has references
     * @param reference - A reference belonging to that request
     * @return Whether the contained resource the reference is referring to exist in the request
     */
    private static checkReferencesForContainedResources;
    /**
     * Given a Bundle entry, get all references in the Bundle entry
     * @param entry - An entry from the Bundle
     * @return - any references that the entry contains
     */
    private static getReferences;
    /**
     * Get the resource id specified in the entry
     * @param entry - Entry to parse
     * @param operation - Operation specified in the entry
     */
    private static getResourceId;
    /**
     * Get the resource type specified in the entry
     * @param entry - Entry to parse
     * @param operation - Operation speficied in the entry
     */
    private static getResourceType;
}
