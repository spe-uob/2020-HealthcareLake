import { FhirConfig, FhirVersion, TypeOperation } from 'fhir-works-on-aws-interface';
export default class ConfigHandler {
    readonly config: FhirConfig;
    readonly supportedGenericResources: string[];
    constructor(config: FhirConfig, supportedGenericResources: string[]);
    isVersionSupported(fhirVersion: FhirVersion): boolean;
    getExcludedResourceTypes(fhirVersion: FhirVersion): string[];
    getSpecialResourceTypes(fhirVersion: FhirVersion): string[];
    getSpecialResourceOperations(resourceType: string, fhirVersion: FhirVersion): TypeOperation[];
    getGenericOperations(fhirVersion: FhirVersion): TypeOperation[];
    getGenericResources(fhirVersion: FhirVersion, specialResources?: string[]): string[];
}
