"use strict";
/*
 *  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *  SPDX-License-Identifier: Apache-2.0
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.financialResources = void 0;
const constants_1 = require("./constants");
exports.financialResources = [
    "Coverage",
    "CoverageEligibilityRequest",
    "CoverageEligibilityResponse",
    "EnrollmentRequest",
    "EnrollmentResponse",
    "Claim",
    "ClaimResponse",
    "Invoice",
    "PaymentNotice",
    "PaymentReconciliation",
    "Account",
    "ChargeItem",
    "ChargeItemDefinition",
    "Contract",
    "ExplanationOfBenefit",
    "InsurancePlan"
];
const RBACRules = {
    version: 1.0,
    groupRules: {
        practitioner: {
            operations: [
                "create",
                "read",
                "update",
                "delete",
                "vread",
                "search-type",
                "transaction"
            ],
            resources: constants_1.SUPPORTED_R4_RESOURCES
        },
        "non-practitioner": {
            operations: ["read", "vread", "search-type"],
            resources: exports.financialResources
        },
        auditor: {
            operations: ["read", "vread", "search-type"],
            resources: ["Patient"]
        }
    }
};
exports.default = RBACRules;
//# sourceMappingURL=RBACRules.js.map