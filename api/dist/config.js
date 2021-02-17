"use strict";
/*
 *  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *  SPDX-License-Identifier: Apache-2.0
 */
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.genericResources = exports.fhirConfig = void 0;
const fhir_works_on_aws_interface_1 = require("fhir-works-on-aws-interface");
const fhir_works_on_aws_search_es_1 = require("fhir-works-on-aws-search-es");
const fhir_works_on_aws_authz_rbac_1 = require("fhir-works-on-aws-authz-rbac");
const fhir_works_on_aws_persistence_ddb_1 = require("fhir-works-on-aws-persistence-ddb");
const RBACRules_1 = __importDefault(require("./RBACRules"));
const constants_1 = require("./constants");
const { IS_OFFLINE } = process.env;
const fhirVersion = "4.0.1";
const authService = IS_OFFLINE
    ? fhir_works_on_aws_interface_1.stubs.passThroughAuthz
    : new fhir_works_on_aws_authz_rbac_1.RBACHandler(RBACRules_1.default);
const dynamoDbDataService = new fhir_works_on_aws_persistence_ddb_1.DynamoDbDataService(fhir_works_on_aws_persistence_ddb_1.DynamoDb);
const dynamoDbBundleService = new fhir_works_on_aws_persistence_ddb_1.DynamoDbBundleService(fhir_works_on_aws_persistence_ddb_1.DynamoDb);
const esSearch = new fhir_works_on_aws_search_es_1.ElasticSearchService([{ match: { documentStatus: "AVAILABLE" } }], fhir_works_on_aws_persistence_ddb_1.DynamoDbUtil.cleanItem, fhirVersion);
const s3DataService = new fhir_works_on_aws_persistence_ddb_1.S3DataService(dynamoDbDataService, fhirVersion);
exports.fhirConfig = {
    configVersion: 1.0,
    orgName: "Organization Name",
    auth: {
        authorization: authService,
        // Used in Capability Statement Generation only
        strategy: {
            service: "OAuth",
            oauthUrl: process.env.OAUTH2_DOMAIN_ENDPOINT === "[object Object]" ||
                process.env.OAUTH2_DOMAIN_ENDPOINT === undefined
                ? "https://OAUTH2.com"
                : process.env.OAUTH2_DOMAIN_ENDPOINT
        }
    },
    server: {
        // When running serverless offline, env vars are expressed as '[object Object]'
        // https://github.com/serverless/serverless/issues/7087
        // As of May 14, 2020, this bug has not been fixed and merged in
        // https://github.com/serverless/serverless/pull/7147
        url: process.env.API_URL === "[object Object]" ||
            process.env.API_URL === undefined
            ? "https://API_URL.com"
            : process.env.API_URL
    },
    logging: {
        // Unused at this point
        level: "error"
    },
    profile: {
        systemOperations: ["transaction"],
        bundle: dynamoDbBundleService,
        systemHistory: fhir_works_on_aws_interface_1.stubs.history,
        systemSearch: fhir_works_on_aws_interface_1.stubs.search,
        fhirVersion,
        genericResource: {
            operations: [
                "create",
                "read",
                "update",
                "delete",
                "vread",
                "search-type"
            ],
            fhirVersions: [fhirVersion],
            persistence: dynamoDbDataService,
            typeSearch: esSearch,
            typeHistory: fhir_works_on_aws_interface_1.stubs.history
        },
        resources: {
            Binary: {
                operations: ["create", "read", "update", "delete", "vread"],
                fhirVersions: [fhirVersion],
                persistence: s3DataService,
                typeSearch: fhir_works_on_aws_interface_1.stubs.search,
                typeHistory: fhir_works_on_aws_interface_1.stubs.history
            }
        }
    }
};
exports.genericResources = fhirVersion === "4.0.1" ? constants_1.SUPPORTED_R4_RESOURCES : constants_1.SUPPORTED_STU3_RESOURCES;
//# sourceMappingURL=config.js.map