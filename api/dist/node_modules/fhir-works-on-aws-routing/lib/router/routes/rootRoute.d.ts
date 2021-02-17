import { Router } from 'express';
import { Authorization, Bundle, FhirVersion, SystemOperation, Search, History, GenericResource, Resources } from 'fhir-works-on-aws-interface';
export default class RootRoute {
    readonly router: Router;
    private bundleHandler;
    private rootHandler;
    private operations;
    constructor(operations: SystemOperation[], fhirVersion: FhirVersion, serverUrl: string, bundle: Bundle, search: Search, history: History, authService: Authorization, supportedGenericResources: string[], genericResource?: GenericResource, resources?: Resources);
    init(): void;
}
