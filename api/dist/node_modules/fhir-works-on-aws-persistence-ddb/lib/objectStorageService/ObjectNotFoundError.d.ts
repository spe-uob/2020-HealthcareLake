export default class ObjectNotFoundError extends Error {
    readonly filename: string;
    constructor(filename: string, message?: string);
}
