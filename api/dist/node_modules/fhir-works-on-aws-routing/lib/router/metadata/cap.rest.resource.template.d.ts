import { TypeOperation, SystemOperation } from 'fhir-works-on-aws-interface';
export declare function makeOperation(operations: (TypeOperation | SystemOperation)[]): any[];
export declare function makeGenericResources(fhirResourcesToMake: string[], operations: TypeOperation[]): any[];
export declare function makeResource(resourceType: string, operations: TypeOperation[]): any;
