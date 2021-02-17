"use strict";
/*
 *  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *  SPDX-License-Identifier: Apache-2.0
 */
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
var _a;
Object.defineProperty(exports, "__esModule", { value: true });
const s3_1 = require("./s3");
const ObjectNotFoundError_1 = __importDefault(require("./ObjectNotFoundError"));
const S3ObjectStorageService = (_a = class {
        static async uploadObject(data, fileName, contentType) {
            // @ts-ignore
            // eslint-disable-next-line new-cap
            const base64Data = new Buffer.from(data, 'base64');
            const params = {
                Bucket: s3_1.FHIR_BINARY_BUCKET,
                Key: fileName,
                Body: base64Data,
                ContentEncoding: 'base64',
                ContentType: contentType,
                ServerSideEncryption: this.SSE_ALGORITHM,
                SSEKMSKeyId: this.S3_KMS_KEY,
            };
            try {
                const { Key } = await s3_1.S3.upload(params).promise();
                return { message: Key };
            }
            catch (e) {
                const message = 'Failed uploading binary data to S3';
                console.error(message, e);
                throw e;
            }
        }
        static async readObject(fileName) {
            const params = {
                Bucket: s3_1.FHIR_BINARY_BUCKET,
                Key: fileName,
            };
            try {
                const object = await s3_1.S3.getObject(params).promise();
                if (object.Body) {
                    const base64Data = object.Body.toString('base64');
                    return { message: base64Data };
                }
                throw new Error('S3 object body is empty');
            }
            catch (e) {
                const message = "Can't read object";
                console.error(message, e);
                throw e;
            }
        }
        static async deleteObject(fileName) {
            const params = {
                Bucket: s3_1.FHIR_BINARY_BUCKET,
                Key: fileName,
            };
            console.log('Delete Params', params);
            await s3_1.S3.deleteObject(params).promise();
            return { message: '' };
        }
        static async getPresignedPutUrl(fileName) {
            const url = await s3_1.S3.getSignedUrlPromise('putObject', {
                Bucket: s3_1.FHIR_BINARY_BUCKET,
                Key: fileName,
                Expires: this.PRESIGNED_URL_EXPIRATION_IN_SECONDS,
                ServerSideEncryption: this.SSE_ALGORITHM,
                SSEKMSKeyId: this.S3_KMS_KEY,
            });
            return { message: url };
        }
        static async getPresignedGetUrl(fileName) {
            // Check to see whether S3 file exists
            try {
                await s3_1.S3.headObject({
                    Bucket: s3_1.FHIR_BINARY_BUCKET,
                    Key: fileName,
                }).promise();
            }
            catch (e) {
                console.error(`File does not exist. FileName: ${fileName}`);
                throw new ObjectNotFoundError_1.default(fileName);
            }
            try {
                const url = await s3_1.S3.getSignedUrlPromise('getObject', {
                    Bucket: s3_1.FHIR_BINARY_BUCKET,
                    Key: fileName,
                    Expires: this.PRESIGNED_URL_EXPIRATION_IN_SECONDS,
                });
                return { message: url };
            }
            catch (e) {
                console.error('Failed creating presigned S3 GET URL', e);
                throw e;
            }
        }
        static async deleteBasedOnPrefix(prefix) {
            let token;
            const promises = [];
            do {
                const listParams = {
                    Bucket: s3_1.FHIR_BINARY_BUCKET,
                    Prefix: prefix,
                    ContinuationToken: token,
                };
                // eslint-disable-next-line no-await-in-loop
                const results = await s3_1.S3.listObjectsV2(listParams).promise();
                const contents = results.Contents || [];
                token = results.ContinuationToken;
                const keysToDelete = contents.map(content => {
                    return { Key: content.Key };
                });
                const params = {
                    Bucket: s3_1.FHIR_BINARY_BUCKET,
                    Delete: {
                        Objects: keysToDelete,
                    },
                };
                console.log('Delete Params', params);
                promises.push(s3_1.S3.deleteObjects(params).promise());
            } while (token);
            try {
                await Promise.all(promises);
            }
            catch (e) {
                const message = 'Deletion has failed, please retry';
                console.error(message, e);
                throw e;
            }
            return { message: '' };
        }
    },
    _a.S3_KMS_KEY = process.env.S3_KMS_KEY || '',
    _a.SSE_ALGORITHM = 'aws:kms',
    _a.PRESIGNED_URL_EXPIRATION_IN_SECONDS = 300,
    _a);
exports.default = S3ObjectStorageService;
//# sourceMappingURL=s3ObjectStorageService.js.map