"use strict";
/*
 *  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *  SPDX-License-Identifier: Apache-2.0
 */
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const ajv_1 = __importDefault(require("ajv"));
// @ts-ignore
const json_schema_draft_06_json_1 = __importDefault(require("ajv/lib/refs/json-schema-draft-06.json"));
const json_schema_draft_04_json_1 = __importDefault(require("ajv/lib/refs/json-schema-draft-04.json"));
// @ts-ignore
const fhir_works_on_aws_interface_1 = require("fhir-works-on-aws-interface");
const fhir_schema_v4_json_1 = __importDefault(require("./schemas/fhir.schema.v4.json"));
const fhir_schema_v3_json_1 = __importDefault(require("./schemas/fhir.schema.v3.json"));
class Validator {
    constructor(fhirVersion) {
        const ajv = new ajv_1.default({ schemaId: 'auto', allErrors: true });
        if (fhirVersion === '4.0.1') {
            ajv.addMetaSchema(json_schema_draft_06_json_1.default);
            ajv.addSchema(fhir_schema_v4_json_1.default);
        }
        if (fhirVersion === '3.0.1') {
            ajv.addMetaSchema(json_schema_draft_04_json_1.default);
            ajv.addSchema(fhir_schema_v3_json_1.default);
        }
        this.ajv = ajv;
    }
    validate(definitionName, data) {
        const referenceName = `#/definitions/${definitionName}`;
        const result = this.ajv.validate(referenceName, data);
        if (!result) {
            throw new fhir_works_on_aws_interface_1.InvalidResourceError(this.ajv.errorsText());
        }
        return { message: 'Success' };
    }
}
exports.default = Validator;
//# sourceMappingURL=validator.js.map