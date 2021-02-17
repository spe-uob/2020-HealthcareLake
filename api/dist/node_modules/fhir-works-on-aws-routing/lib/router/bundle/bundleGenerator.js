"use strict";
/*
 *  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *  SPDX-License-Identifier: Apache-2.0
 */
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const v4_1 = __importDefault(require("uuid/v4"));
const url_1 = __importDefault(require("url"));
class BundleGenerator {
    // https://www.hl7.org/fhir/search.html
    static generateBundle(baseUrl, queryParams, searchResult, bundleType, resourceType, id) {
        const currentDateTime = new Date();
        const bundle = {
            resourceType: 'Bundle',
            id: v4_1.default(),
            meta: {
                lastUpdated: currentDateTime.toISOString(),
            },
            type: bundleType,
            total: searchResult.numberOfResults,
            link: [this.createLinkWithQuery('self', baseUrl, bundleType === 'history', resourceType, id, queryParams)],
            entry: searchResult.entries,
        };
        if (searchResult.previousResultUrl) {
            bundle.link.push(this.createLink('previous', searchResult.previousResultUrl));
        }
        if (searchResult.nextResultUrl) {
            bundle.link.push(this.createLink('next', searchResult.nextResultUrl));
        }
        if (searchResult.firstResultUrl) {
            bundle.link.push(this.createLink('first', searchResult.firstResultUrl));
        }
        if (searchResult.lastResultUrl) {
            bundle.link.push(this.createLink('last', searchResult.lastResultUrl));
        }
        return bundle;
    }
    static createLinkWithQuery(linkType, host, isHistory, resourceType, id, query) {
        let pathname = '';
        if (resourceType) {
            pathname += `/${resourceType}`;
        }
        if (id) {
            pathname += `/${id}`;
        }
        if (isHistory) {
            pathname += '/_history';
        }
        return {
            relation: linkType,
            url: url_1.default.format({
                host,
                pathname,
                query,
            }),
        };
    }
    static createLink(linkType, url) {
        return {
            relation: linkType,
            url,
        };
    }
    static generateTransactionBundle(baseUrl, bundleEntryResponses) {
        const id = v4_1.default();
        const response = {
            resourceType: 'Bundle',
            id,
            type: 'transaction-response',
            link: [
                {
                    relation: 'self',
                    url: baseUrl,
                },
            ],
            entry: [],
        };
        const entries = [];
        bundleEntryResponses.forEach(bundleEntryResponse => {
            const status = bundleEntryResponse.operation === 'create' ? '201 Created' : '200 OK';
            const entry = {
                response: {
                    status,
                    location: `${bundleEntryResponse.resourceType}/${bundleEntryResponse.id}`,
                    etag: bundleEntryResponse.vid,
                    lastModified: bundleEntryResponse.lastModified,
                },
            };
            if (bundleEntryResponse.operation === 'read') {
                entry.resource = bundleEntryResponse.resource;
            }
            entries.push(entry);
        });
        response.entry = entries;
        return response;
    }
}
exports.default = BundleGenerator;
//# sourceMappingURL=bundleGenerator.js.map