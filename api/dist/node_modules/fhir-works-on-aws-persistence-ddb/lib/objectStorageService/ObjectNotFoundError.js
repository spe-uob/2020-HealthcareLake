"use strict";
/*
 *  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *  SPDX-License-Identifier: Apache-2.0
 */
Object.defineProperty(exports, "__esModule", { value: true });
class ObjectNotFoundError extends Error {
    constructor(filename, message) {
        const msg = message || 'Object not found';
        // Node Error class requires passing a string message to the parent class
        super(msg);
        Object.setPrototypeOf(this, ObjectNotFoundError.prototype);
        this.filename = filename;
        this.name = this.constructor.name;
    }
}
exports.default = ObjectNotFoundError;
//# sourceMappingURL=ObjectNotFoundError.js.map