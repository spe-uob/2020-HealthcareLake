import { Search, TypeSearchRequest, SearchResponse, GlobalSearchRequest, FhirVersion } from 'fhir-works-on-aws-interface';
export declare class ElasticSearchService implements Search {
    private readonly filterRulesForActiveResources;
    private readonly cleanUpFunction;
    private readonly fhirVersion;
    /**
     * @param filterRulesForActiveResources - If you are storing both History and Search resources
     * in your elastic search you can filter out your History elements by supplying a filter argument like:
     * [{ match: { documentStatus: 'AVAILABLE' }}]
     * @param cleanUpFunction - If you are storing non-fhir related parameters pass this function to clean
     * the return ES objects
     * @param fhirVersion
     */
    constructor(filterRulesForActiveResources?: any[], cleanUpFunction?: (resource: any) => any, fhirVersion?: FhirVersion);
    typeSearch(request: TypeSearchRequest): Promise<SearchResponse>;
    private executeQuery;
    private executeQueries;
    private hitsToSearchEntries;
    private processSearchInclusions;
    private processIterativeSearchInclusions;
    private createURL;
    globalSearch(request: GlobalSearchRequest): Promise<SearchResponse>;
}
