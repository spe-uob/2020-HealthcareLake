"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.buildRevIncludeQueries = exports.buildIncludeQueries = exports.buildRevIncludeQuery = exports.buildIncludeQuery = exports.getRevincludeReferencesFromResources = exports.getIncludeReferencesFromResources = exports.getInclusionParametersFromQueryParams = exports.inclusionParameterFromString = void 0;
/*
 *  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *  SPDX-License-Identifier: Apache-2.0
 */
const lodash_1 = require("lodash");
const fhirResourceReferencesMatrix_v4_0_1_json_1 = __importDefault(require("./schema/fhirResourceReferencesMatrix.v4.0.1.json"));
const fhirResourceReferencesMatrix_v3_0_1_json_1 = __importDefault(require("./schema/fhirResourceReferencesMatrix.v3.0.1.json"));
const tsUtils_1 = require("./tsUtils");
exports.inclusionParameterFromString = (s) => {
    if (s === '*') {
        return { isWildcard: true };
    }
    const INCLUSION_PARAM_REGEX = /^(?<sourceResource>[A-Za-z]+):(?<searchParameter>[A-Za-z.]+)(?::(?<targetResourceType>[A-Za-z]+))?$/;
    const match = s.match(INCLUSION_PARAM_REGEX);
    if (match === null) {
        // Malformed inclusion search parameters are ignored. No exception is thrown.
        // This allows the regular search to complete successfully
        console.log(`Ignoring invalid include/revinclude search parameter: ${s}`);
        return null;
    }
    const { sourceResource, searchParameter, targetResourceType } = match.groups;
    return {
        isWildcard: false,
        sourceResource,
        searchParameter,
        targetResourceType,
    };
};
const expandRevIncludeWildcard = (resourceTypes, resourceReferencesMatrix) => {
    return resourceTypes.flatMap(resourceType => {
        return resourceReferencesMatrix
            .filter(
        // Some Resources have fields that can reference any resource type. They have their type noted as Reference(Any) on the FHIR website.
        // In those cases the targetResourceType is noted as 'Resource' in the references matrix.
        ([, , targetResourceType]) => targetResourceType === resourceType || targetResourceType === 'Resource')
            .map(([sourceResource, searchParameter, targetResourceType]) => ({
            type: '_revinclude',
            isWildcard: false,
            sourceResource,
            searchParameter,
            targetResourceType: targetResourceType === 'Resource' ? undefined : targetResourceType,
        }));
    });
};
const expandIncludeWildcard = (resourceTypes, resourceReferencesMatrix) => {
    return resourceTypes.flatMap(resourceType => {
        return resourceReferencesMatrix
            .filter(([sourceResource, ,]) => sourceResource === resourceType)
            .map(([sourceResource, searchParameter, targetResourceType]) => ({
            type: '_include',
            isWildcard: false,
            sourceResource,
            searchParameter,
            targetResourceType: targetResourceType === 'Resource' ? undefined : targetResourceType,
        }));
    });
};
exports.getInclusionParametersFromQueryParams = (includeType, queryParams, iterate) => {
    const includeTypeKey = iterate ? `${includeType}:iterate` : includeType;
    const queryParam = queryParams === null || queryParams === void 0 ? void 0 : queryParams[includeTypeKey];
    if (!queryParam) {
        return [];
    }
    if (Array.isArray(queryParam)) {
        return lodash_1.uniq(queryParam)
            .map(param => exports.inclusionParameterFromString(param))
            .filter(tsUtils_1.isPresent)
            .map(inclusionParam => ({ type: includeType, ...inclusionParam }));
    }
    const inclusionParameter = exports.inclusionParameterFromString(queryParam);
    if (inclusionParameter === null) {
        return [];
    }
    return [{ type: includeType, isIterate: iterate, ...inclusionParameter }];
};
const RELATIVE_URL_REGEX = /^[A-Za-z]+\/[A-Za-z0-9-]+$/;
exports.getIncludeReferencesFromResources = (includes, resources) => {
    const references = includes.flatMap(include => {
        return resources
            .filter(resource => resource.resourceType === include.sourceResource)
            .map(resource => lodash_1.get(resource, `${include.searchParameter}`))
            .flatMap(valueAtPath => {
            if (Array.isArray(valueAtPath)) {
                return valueAtPath.map(v => lodash_1.get(v, 'reference'));
            }
            return [lodash_1.get(valueAtPath, 'reference')];
        })
            .filter((reference) => typeof reference === 'string')
            .filter(reference => RELATIVE_URL_REGEX.test(reference))
            .map(relativeUrl => {
            const [resourceType, id] = relativeUrl.split('/');
            return { resourceType, id };
        })
            .filter(({ resourceType }) => !include.targetResourceType || include.targetResourceType === resourceType);
    });
    return lodash_1.uniqBy(references, x => `${x.resourceType}/${x.id}`);
};
exports.getRevincludeReferencesFromResources = (revIncludeParameters, resources) => {
    return revIncludeParameters
        .map(revinclude => {
        const references = resources
            .filter(resource => revinclude.targetResourceType === undefined ||
            resource.resourceType === revinclude.targetResourceType)
            .map(resource => `${resource.resourceType}/${resource.id}`);
        return { revinclude, references };
    })
        .filter(({ references }) => references.length > 0);
};
exports.buildIncludeQuery = (resourceType, resourceIds, filterRulesForActiveResources) => ({
    index: resourceType.toLowerCase(),
    body: {
        query: {
            bool: {
                filter: [
                    {
                        terms: {
                            id: resourceIds,
                        },
                    },
                    ...filterRulesForActiveResources,
                ],
            },
        },
    },
});
exports.buildRevIncludeQuery = (revIncludeSearchParameter, references, filterRulesForActiveResources) => {
    const { sourceResource, searchParameter } = revIncludeSearchParameter;
    return {
        index: sourceResource.toLowerCase(),
        body: {
            query: {
                bool: {
                    filter: [
                        {
                            terms: {
                                [`${searchParameter}.reference.keyword`]: references,
                            },
                        },
                        ...filterRulesForActiveResources,
                    ],
                },
            },
        },
    };
};
const getResourceReferenceMatrix = (fhirVersion) => {
    if (fhirVersion === '4.0.1') {
        return fhirResourceReferencesMatrix_v4_0_1_json_1.default;
    }
    if (fhirVersion === '3.0.1') {
        return fhirResourceReferencesMatrix_v3_0_1_json_1.default;
    }
    return [];
};
exports.buildIncludeQueries = (queryParams, resources, filterRulesForActiveResources, fhirVersion, iterate) => {
    const allIncludeParameters = exports.getInclusionParametersFromQueryParams('_include', queryParams, iterate);
    const includeParameters = allIncludeParameters.some(x => x.isWildcard)
        ? expandIncludeWildcard([
            ...resources.reduce((acc, resource) => acc.add(resource.resourceType), new Set()),
        ], getResourceReferenceMatrix(fhirVersion))
        : allIncludeParameters;
    const resourceReferences = exports.getIncludeReferencesFromResources(includeParameters, resources);
    const resourceTypeToIds = lodash_1.mapValues(lodash_1.groupBy(resourceReferences, resourcReference => resourcReference.resourceType), arr => arr.map(x => x.id));
    const searchQueries = Object.entries(resourceTypeToIds).map(([resourceType, ids]) => {
        return exports.buildIncludeQuery(resourceType, ids, filterRulesForActiveResources);
    });
    return searchQueries;
};
exports.buildRevIncludeQueries = (queryParams, resources, filterRulesForActiveResources, fhirVersion, iterate) => {
    const allRevincludeParameters = exports.getInclusionParametersFromQueryParams('_revinclude', queryParams, iterate);
    const revIncludeParameters = allRevincludeParameters.some(x => x.isWildcard)
        ? expandRevIncludeWildcard([
            ...resources.reduce((acc, resource) => acc.add(resource.resourceType), new Set()),
        ], getResourceReferenceMatrix(fhirVersion))
        : allRevincludeParameters;
    const revincludeReferences = exports.getRevincludeReferencesFromResources(revIncludeParameters, resources);
    const searchQueries = revincludeReferences.map(({ revinclude, references }) => exports.buildRevIncludeQuery(revinclude, references, filterRulesForActiveResources));
    return searchQueries;
};
//# sourceMappingURL=searchInclusions.js.map