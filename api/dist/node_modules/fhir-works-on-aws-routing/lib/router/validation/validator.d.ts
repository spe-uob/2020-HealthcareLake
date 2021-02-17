import { GenericResponse, FhirVersion } from 'fhir-works-on-aws-interface';
export default class Validator {
    private ajv;
    constructor(fhirVersion: FhirVersion);
    validate(definitionName: string, data: any): GenericResponse;
}
