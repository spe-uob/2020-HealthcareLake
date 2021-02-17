import { Router } from 'express';
import { Authorization, TypeOperation } from 'fhir-works-on-aws-interface';
import CrudHandlerInterface from '../handlers/CrudHandlerInterface';
export default class GenericResourceRoute {
    readonly operations: TypeOperation[];
    readonly router: Router;
    private handler;
    private readonly authService;
    constructor(operations: TypeOperation[], handler: CrudHandlerInterface, authService: Authorization);
    private init;
}
