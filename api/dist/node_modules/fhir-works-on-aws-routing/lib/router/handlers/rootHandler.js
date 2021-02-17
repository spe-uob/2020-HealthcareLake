"use strict";
/*
 *  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *  SPDX-License-Identifier: Apache-2.0
 */
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const bundleGenerator_1 = __importDefault(require("../bundle/bundleGenerator"));
class RootHandler {
    constructor(searchService, historyService, serverUrl) {
        this.searchService = searchService;
        this.historyService = historyService;
        this.serverUrl = serverUrl;
    }
    async globalSearch(queryParams) {
        const searchResponse = await this.searchService.globalSearch({
            queryParams,
            baseUrl: this.serverUrl,
        });
        return bundleGenerator_1.default.generateBundle(this.serverUrl, queryParams, searchResponse.result, 'searchset');
    }
    async globalHistory(queryParams) {
        const historyResponse = await this.historyService.globalHistory({
            queryParams,
            baseUrl: this.serverUrl,
        });
        return bundleGenerator_1.default.generateBundle(this.serverUrl, queryParams, historyResponse.result, 'history');
    }
}
exports.default = RootHandler;
//# sourceMappingURL=rootHandler.js.map