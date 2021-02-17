import express from 'express';
export declare const applicationErrorMapper: (err: any, req: express.Request, res: express.Response, next: express.NextFunction) => void;
export declare const httpErrorHandler: (err: any, req: express.Request, res: express.Response, next: express.NextFunction) => void;
export declare const unknownErrorHandler: (err: any, req: express.Request, res: express.Response, next: express.NextFunction) => void;
