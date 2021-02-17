"use strict";
/*
 *  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *  SPDX-License-Identifier: Apache-2.0
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.makeResource = exports.makeGenericResources = exports.makeOperation = void 0;
function makeResourceObject(resourceType, resourceOperations, updateCreate, hasTypeSearch) {
    const result = {
        type: resourceType,
        interaction: resourceOperations,
        versioning: 'versioned',
        readHistory: false,
        updateCreate,
        conditionalCreate: false,
        conditionalRead: 'not-supported',
        conditionalUpdate: false,
        conditionalDelete: 'not-supported',
    };
    // TODO: Handle case where user specify exactly which search parameters is supported for each resource
    if (hasTypeSearch) {
        result.searchParam = [
            {
                name: 'ALL',
                type: 'composite',
                documentation: 'Support all fields.',
            },
        ];
    }
    return result;
}
function makeOperation(operations) {
    const resourceOperations = [];
    operations.forEach(operation => {
        resourceOperations.push({ code: operation });
    });
    return resourceOperations;
}
exports.makeOperation = makeOperation;
function makeGenericResources(fhirResourcesToMake, operations) {
    const resources = [];
    const resourceOperations = makeOperation(operations);
    const updateCreate = operations.includes('update');
    const hasTypeSearch = operations.includes('search-type');
    fhirResourcesToMake.forEach((resourceType) => {
        resources.push(makeResourceObject(resourceType, resourceOperations, updateCreate, hasTypeSearch));
    });
    return resources;
}
exports.makeGenericResources = makeGenericResources;
function makeResource(resourceType, operations) {
    const resourceOperations = makeOperation(operations);
    const updateCreate = operations.includes('update');
    const hasTypeSearch = operations.includes('search-type');
    const resource = makeResourceObject(resourceType, resourceOperations, updateCreate, hasTypeSearch);
    return resource;
}
exports.makeResource = makeResource;
//# sourceMappingURL=cap.rest.resource.template.js.map