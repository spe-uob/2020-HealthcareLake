# Data Simulation Team

The following instructions are meant to guide you on using our API. You do not need to download anything, but we would recommend testing it in Postman. We have provided you with an up-to-date API documentation that includes example requests and the option to generate code snippets in various languages [here](https://documenter.getpostman.com/view/12190139/TVsoFVgc).

## Usage

To use the API, you will need to ask one of us for the following values:

1. The endpoint URL for the dev stage (`DEV_FHIR_API_ENDPOINT`)
2. The Cognito password (`COGNITO_PASSWORD`)
3. The API key for the dev stage (`DEV_API_KEY`)
4. The `USER_POOL_APP_CLIENT_ID`

You will use the Cognito username ("data-sim-team") and password to request a time-limited Oauth2 token (`COGNITO_AUTH_TOKEN`) from AWS Cognito.

### Accessing the FHIR API

The FHIR API can be accessed through the API_URL using REST syntax as defined by FHIR here

> http://hl7.org/fhir/http.html

using this command

```sh
curl -H "Accept: application/json" -H "Authorization:<COGNITO_AUTH_TOKEN>" -H "x-api-key:<API_KEY>" <API_URL>
```

Other means of accessing the API are valid as well, such as Postman. More details for using Postman are detailed below in the _Using POSTMAN to make API Requests_ section.

#### Using POSTMAN to make API Requests

[POSTMAN](https://www.postman.com/) is an API Client for RESTful services that can run on your development desktop for making requests to the FHIR Server. Postman is highly suggested and will make accessing the FHRI API much easier.

Included in this code package, under the folder “postman”, are JSON definitions for some requests that you can make against the server. To import these requests into your POSTMAN application, you can follow the directions [here](https://kb.datamotion.com/?ht_kb=postman-instructions-for-exporting-and-importing). Be sure to import the collection file.

> [Fhir.postman_collection.json](./postman/FHIR.postman_collection.json)

After you import the collection, you need to set up your environment. You can set up a dev environment for now by importing:

> [Fhir_Dev_Env.json](./postman/Fhir_Dev_Env.json)

The `COGNITO_AUTH_TOKEN` required for this file can be obtained by following the instructions under [Authorizing a user](#authorizing-a-user). The other parameters can be obtained by asking one of the team.

To know what all this FHIR API supports please use the `GET Metadata` postman to generate a [Capability Statement](https://www.hl7.org/fhir/capabilitystatement.html).

### Authorizing a user

The API uses role based access control (RBAC) to determine what operations and what resource types the requesting user has access too. The default ruleset can be found here: [RBACRules.ts](RBACRules.ts). For users to access the API they must use an OAuth2 access token. This access token must include scopes of either:

- `openid profile` Must have both
- `aws.cognito.signin.user.admin`

Using either of the above scopes will include the user groups in the access token.

#### Retrieving an access token via script - easier (scope = aws.cognito.signin.user.admin)

A Cognito OAuth2 access token can be obtained using [this script](./scripts/cognito-auth.py). You may wish to write the equivalent code in Java using the AWS SDK if you prefer.

```sh
$ python3 scripts/init-auth.py <USER_POOL_APP_CLIENT_ID> eu-west-2
```


This script assumes you have set COGNITO_PASSWORD in your environment:
```sh
$ export COGNITO_PASSWORD=your-password-here
```

The return value is the `COGNITO_AUTH_TOKEN` (found in the postman collection) to be used for access to the FHIR APIs

#### Retrieving access token via postman (scope = openid profile)

In order to access the FHIR API, a `COGNITO_AUTH_TOKEN` is required. This can be obtained following the below steps within postman:

1. Open postman and click on the operation you wish to make (i.e. `GET Patient`)
2. In the main screen click on the `Authorization` tab
3. Using the TYPE drop down choose `OAuth 2.0`
4. You should now see a button `Get New Access Token`; Click it
5. For 'Grant Type' choose `Implicit`
6. For 'Callback URL' use `http://localhost`
7. For 'Auth URL' use `https://<USER_POOL_APP_CLIENT_ID>.auth.eu-west-2.amazoncognito.com/oauth2/authorize` which should look something like: `https://92huon34t5jlkrfgon343.auth.eu-west-2.amazoncognito.com/oauth2/authorize`
8. For 'Client ID' use your USER_POOL_APP_CLIENT_ID which should look like: `92huon34t5jlkrfgon343`
9. For 'Scope' use `profile openid`
10. For 'State' use a random string
11. Click `Request Token`
12. A sign in page should pop up where you should put in your username and password
13. Once signed in the access token will be set and you will have access for 24 hours

### Accessing Binary resources

Binary resources are FHIR resources that consist of binary/unstructured data of any kind. This could be X-rays, PDF, video or other files. This implementation of the FHIR API has a dependency on the API Gateway and Lambda services, which currently have limitations in request/response sizes of 10MB and 6MB respectively. This size limitation forced us to look for a workaround. The workaround is a hybrid approach of storing a Binary resource’s _metadata_ in DynamoDB and using S3's get/putPreSignedUrl APIs. So in your requests to the FHIR API you will store/get the Binary's _metadata_ from DynamoDB and in the response object it will also contain a pre-signed S3 URL, which should be used to interact directly with the Binary file.

#### POSTMAN (recommended)

To test we suggest you to use POSTMAN, please see [here](#using-postman-to-make-api-requests) for steps.

#### cURL

To test this with cURL, use the following command:

1. POST a Binary resource to FHIR API:

```sh
curl -H "Accept: application/json" -H "Authorization:<COGNITO_AUTH_TOKEN>" -H "x-api-key:<API_KEY>" --request POST \
  --data '{"resourceType": "Binary", "contentType": "image/jpeg"}' \
  <API_URL>/Binary
```

1. Check the POST's response. There will be a `presignedPutUrl` parameter. Use that pre-signed url to upload your file. See below for command

```sh
curl -v -T "<LOCATION_OF_FILE_TO_UPLOAD>" "<PRESIGNED_PUT_URL>"
```

## Troubleshooting

- Support for STU3 and R4 releases of FHIR is based on the JSON schema provided by HL7. The schema for [R4](https://www.hl7.org/fhir/validation.html) is more restrictive than the schema for [STU3](http://hl7.org/fhir/STU3/validation.html). The STU3 schema doesn’t restrict appending additional fields into the POST/PUT requests of a resource, whereas the R4 schema has a strict definition of what is permitted in the request.

- When making a POST/PUT request to the server, if you get an error that includes the text `Failed to parse request body as JSON resource`, check that you've set the request headers correctly. The header for `Content-Type` should be either `application/json` or `application/fhir+json` If you're using Postman for making requests, in the `Body` tab, be sure to also set the setting to `raw` and `JSON`.

- When opening an issue in this repository, please include: (1) steps to reproduce (2) expected output (3) actual output
