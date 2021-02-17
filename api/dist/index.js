"use strict";
/*
 *  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *  SPDX-License-Identifier: Apache-2.0
 */
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const serverless_http_1 = __importDefault(require("serverless-http"));
const fhir_works_on_aws_routing_1 = require("fhir-works-on-aws-routing");
const config_1 = require("./config");
const serverlessHandler = serverless_http_1.default(fhir_works_on_aws_routing_1.generateServerlessRouter(config_1.fhirConfig, config_1.genericResources), {
    request(request, event) {
        request.user = event.user;
    }
});
exports.default = async (event = {}, context = {}) => {
    return serverlessHandler(event, context);
};
//# sourceMappingURL=index.js.map