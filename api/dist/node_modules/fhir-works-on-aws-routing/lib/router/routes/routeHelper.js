"use strict";
/*
 *  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *  SPDX-License-Identifier: Apache-2.0
 */
Object.defineProperty(exports, "__esModule", { value: true });
class RouteHelper {
}
exports.default = RouteHelper;
// https://thecodebarbarian.com/80-20-guide-to-express-error-handling
RouteHelper.wrapAsync = (fn) => {
    // eslint-disable-next-line func-names
    return function (req, res, next) {
        // Make sure to `.catch()` any errors and pass them along to the `next()`
        // middleware in the chain, in this case the error handler.
        fn(req, res, next).catch(next);
    };
};
//# sourceMappingURL=routeHelper.js.map