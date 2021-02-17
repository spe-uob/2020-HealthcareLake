import { FhirVersion } from 'fhir-works-on-aws-interface';
export declare type InclusionSearchParameter = {
    type: '_include' | '_revinclude';
    isWildcard: false;
    isIterate?: true;
    sourceResource: string;
    searchParameter: string;
    targetResourceType?: string;
};
export declare type WildcardInclusionSearchParameter = {
    type: '_include' | '_revinclude';
    isWildcard: true;
    isIterate?: true;
};
export declare const inclusionParameterFromString: (s: string) => Omit<InclusionSearchParameter, 'type'> | Omit<WildcardInclusionSearchParameter, 'type'> | null;
export declare const getInclusionParametersFromQueryParams: (includeType: '_include' | '_revinclude', queryParams: any, iterate?: true | undefined) => (InclusionSearchParameter | WildcardInclusionSearchParameter)[];
export declare const getIncludeReferencesFromResources: (includes: InclusionSearchParameter[], resources: any[]) => {
    resourceType: string;
    id: string;
}[];
export declare const getRevincludeReferencesFromResources: (revIncludeParameters: InclusionSearchParameter[], resources: any[]) => {
    references: string[];
    revinclude: InclusionSearchParameter;
}[];
export declare const buildIncludeQuery: (resourceType: string, resourceIds: string[], filterRulesForActiveResources: any[]) => {
    index: string;
    body: {
        query: {
            bool: {
                filter: any[];
            };
        };
    };
};
export declare const buildRevIncludeQuery: (revIncludeSearchParameter: InclusionSearchParameter, references: string[], filterRulesForActiveResources: any[]) => {
    index: string;
    body: {
        query: {
            bool: {
                filter: any[];
            };
        };
    };
};
export declare const buildIncludeQueries: (queryParams: any, resources: any[], filterRulesForActiveResources: any[], fhirVersion: FhirVersion, iterate?: true | undefined) => any[];
export declare const buildRevIncludeQueries: (queryParams: any, resources: any[], filterRulesForActiveResources: any[], fhirVersion: FhirVersion, iterate?: true | undefined) => {
    index: string;
    body: {
        query: {
            bool: {
                filter: any[];
            };
        };
    };
}[];
