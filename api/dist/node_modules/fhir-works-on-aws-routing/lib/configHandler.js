"use strict";
/*
 *  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *  SPDX-License-Identifier: Apache-2.0
 */
Object.defineProperty(exports, "__esModule", { value: true });
class ConfigHandler {
    constructor(config, supportedGenericResources) {
        this.config = config;
        this.supportedGenericResources = supportedGenericResources;
    }
    isVersionSupported(fhirVersion) {
        return this.config.profile.fhirVersion === fhirVersion;
    }
    getExcludedResourceTypes(fhirVersion) {
        const { genericResource } = this.config.profile;
        if (genericResource && genericResource.fhirVersions.includes(fhirVersion)) {
            if (fhirVersion === '3.0.1') {
                return genericResource.excludedSTU3Resources || [];
            }
            if (fhirVersion === '4.0.1') {
                return genericResource.excludedR4Resources || [];
            }
        }
        return [];
    }
    getSpecialResourceTypes(fhirVersion) {
        const { resources } = this.config.profile;
        if (resources) {
            let specialResources = Object.keys(resources);
            specialResources = specialResources.filter(r => resources[r].fhirVersions.includes(fhirVersion));
            return specialResources;
        }
        return [];
    }
    getSpecialResourceOperations(resourceType, fhirVersion) {
        const { resources } = this.config.profile;
        if (resources && resources[resourceType] && resources[resourceType].fhirVersions.includes(fhirVersion)) {
            return resources[resourceType].operations;
        }
        return [];
    }
    getGenericOperations(fhirVersion) {
        const { genericResource } = this.config.profile;
        if (genericResource && genericResource.fhirVersions.includes(fhirVersion)) {
            return genericResource.operations;
        }
        return [];
    }
    getGenericResources(fhirVersion, specialResources = []) {
        const excludedResources = this.getExcludedResourceTypes(fhirVersion);
        const resources = this.supportedGenericResources.filter(r => !excludedResources.includes(r) && !specialResources.includes(r));
        return resources;
    }
}
exports.default = ConfigHandler;
//# sourceMappingURL=configHandler.js.map