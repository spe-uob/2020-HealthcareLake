"use strict";
/*
 *  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *  SPDX-License-Identifier: Apache-2.0
 */
Object.defineProperty(exports, "__esModule", { value: true });
function makeStatement(rest, orgName, url, fhirVersion) {
    const cap = {
        resourceType: 'CapabilityStatement',
        status: 'active',
        date: new Date().toISOString(),
        publisher: orgName,
        kind: 'instance',
        software: {
            name: 'FHIR Server',
            version: '1.0.0',
        },
        implementation: {
            description: `A FHIR ${fhirVersion} Server`,
            url,
        },
        fhirVersion,
        format: ['json'],
        rest: [rest],
    };
    // TODO finalize
    if (fhirVersion !== '4.0.1') {
        cap.acceptUnknown = 'no';
    }
    return cap;
}
exports.default = makeStatement;
//# sourceMappingURL=cap.template.js.map