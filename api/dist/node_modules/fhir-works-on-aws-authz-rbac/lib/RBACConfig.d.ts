import { TypeOperation, SystemOperation } from 'fhir-works-on-aws-interface';
export interface RBACConfig {
    version: number;
    groupRules: GroupRule;
}
export interface GroupRule {
    [groupName: string]: Rule;
}
export interface Rule {
    operations: (TypeOperation | SystemOperation)[];
    resources: string[];
}
