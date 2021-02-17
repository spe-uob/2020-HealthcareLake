import express from 'express';
export default class RouteHelper {
    static wrapAsync: (fn: any) => (req: express.Request, res: express.Response, next: express.NextFunction) => void;
}
