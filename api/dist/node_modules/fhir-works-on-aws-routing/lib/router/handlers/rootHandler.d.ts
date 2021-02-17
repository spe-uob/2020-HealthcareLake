import { Search, History } from 'fhir-works-on-aws-interface';
export default class RootHandler {
    private searchService;
    private historyService;
    private serverUrl;
    constructor(searchService: Search, historyService: History, serverUrl: string);
    globalSearch(queryParams: any): Promise<{
        resourceType: string;
        id: string;
        meta: {
            lastUpdated: string;
        };
        type: "searchset" | "history";
        total: number;
        link: {
            relation: "next" | "self" | "previous" | "first" | "last";
            url: string;
        }[];
        entry: import("fhir-works-on-aws-interface").SearchEntry[];
    }>;
    globalHistory(queryParams: any): Promise<{
        resourceType: string;
        id: string;
        meta: {
            lastUpdated: string;
        };
        type: "searchset" | "history";
        total: number;
        link: {
            relation: "next" | "self" | "previous" | "first" | "last";
            url: string;
        }[];
        entry: import("fhir-works-on-aws-interface").SearchEntry[];
    }>;
}
