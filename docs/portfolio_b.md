# Healthcare Data Lake - Portfolio B

## Overview
- Our client is Dr Philip D Harfield, Health Data Scientist (Informatics) at NIHR Bristol Biomedical Research Centre, University of Bristol. He has Representative Project, HDR-UK South West Better Care Partnership.
- The Domain of our project is the Healthcare Analytics Environment team who will design, implement and test a set of candidate cloud-hosted analytics environments that provide sufficient functionality while also maintaining a source data environment. The overall domain of the 3 teams(Healthcare Data Lake Team, Healthcare Analysis Team and Healthcare Simulation Team) is NHS Healthier Together Sustainability Transformation Partnership Bristol, North Somerset, and South Gloucestershire(BNSSG) & Bristol Biomedical Research Centre, University of Bristol Medical School.
- The project entails combining a wealth of data from data owners(GPs Patient data, ambluance services, 111, mental health services .etc) into a data lake. The data in the data lake would be accessed and utilized by those such as data scientists of medical care. This will be used to inform clinical decisions making by providing more advanced insights into the longitudinal health of the patient on arrival and understand the merits of previous clinic decisions taken. The project is one of three designed an end-to-end proof of concept to the local NHS. We will be working alongside the "Healthcare Data Visualisation" and "Healthcare Analytics Environment" teams.
- The Healthcare Data Lake Project is evisioning a future integrated data storage solution, one that is scalable and portable, while using the latest cloud-based technologies. Starting with a prototype, the final scope is to create, alongside the Simulation and Analytics Projects, a system that is going to change how data is handled and used in the healthcare system. There is the real possibility that this three projects will represent the cornerstone of a future solution used and developed extensively by the NHS, which will bring immediate aid to the average medical worker and improve the quality of the service provided to the patients.

## Stakeholder and Requirements

### Primary Stakeholder

Philip Harfield is our client and primary stakeholder, and this software is being developed for him at Bristol, North Somerset and South Gloucestershire NHS CCG
(BNSSG). 

- The primary user story for this stakeholder is that BNSSG may require information about long-term data analytics from multiple sources. E.g how the long term health of patients has been affected by particular surgeries in childhood. This information could then be used to inform understanding of the merits of
previous clinical decisions taken.
- Additionally, another user story is it may require information in a more short term basis about the healthcare of the local population. E.g  to determine what percentage of people registered with a GP have been admitted to hospital in a given year. This information could then be used to inform strategic commissioning decisions on local healthcare services.
- Also BNSSG may want to use the software to curate datamarts from the data which can then be queried by external clients while maintaining security of the data lake. E.g A datamart could be curated of non-identifiable patient data of people who have had particular condition, so external research can be carried out on this condition without breaching data regulations. 

Now considering the user stories above, we can breakdown the story into a sequence of steps of user flow:

1. BNSSG wish to access the data, to do a query on how a particular surgery affects healthcare outcomes.
2. BNSSG use their secure access credentials to gain access to the lake.
3. BNSSG use a data analytics environment of their choice to query the lake based on records where the patient has had a particular surgery.
4. Clinical or strategical commissioning decisions can be taken based on the data.

Alternatively, the following user flow could take place for this stakeholder:

1. BNSSG wish to access the data, to do a query on how a particular surgery affects healthcare outcomes. 
2. BNSSG use their secure access credentials to gain access to the lake.
3. BNSSG queries an already created data mart containing only data which is a appropriate to its research. 
4. BNSSG analyses this data using an analytics environment of their choice.
5. Clinical or strategical commissioning decisions can be taken based on the data.

Exceptionally, the following user flow could take place:
 
1. BNSSG wish to access the data, to do a query on how a particular surgery affects healthcare outcomes.
2. BNSSG data analysts provide secure access credentials
3. The analysts receive a message that these user credentials are not valid. 
4. Access to the data is not granted.

### Additional Stakeholders

As well as our primary stakeholder as described above, we have additional interacting and non-interacting stakeholders. Some of these interacting stakeholders will be local healthcare organisations that will be supplying data to the data lake.

One of these local healthcare organisations, for example, could be the Bristol Student Health GP service.  This service offers GP healthcare to the majority of students at the University of Bristol and would have the following user stories when interacting with our software.

- A student may attend their GP with a health concern, which a GP can diagnose. A record of this can be sent to the data lake to be securely stored and used in analysis.
- A student may have a measurement taken when attending the GP, for example a height, weight or blood pressure measurement. This measurement can be then sent to the data lake to be stored with their record. A healthcare organisation could then monitor change over time or carry out other analytics.
- Finally a patient could contact the GP service to update their details, such as an address. This update of data can then be stored in the data lake to ensure that data is kept accurate and up to date.

Now considering the first user story above, we can break down the story into flow steps.

1. A patient attends the Student Health Service with a condition. 
2. A healthcare practitioner diagnoses this condition.
3. The Student Health Service wishes to send this data to the data lake.
3. The Student Health Service authenticates their identity and is provided with a secure access token.
4. The data is sent to the data lake securely via an API in the format of a FHIR message (industry standard for healthcare information)
5. The data is accepted by the API and an acceptance message is sent to the GP service.
6. The data is converted to a common data model format and securely stored.
7. The data can be queried and analysed as required.

We can also identify exceptional flow for this user story:

1. A patient attends the Student Health Service with a condition. 
2. A healthcare practitioner diagnoses this condition.
3. The Student Health Service wishes to send this data to the data lake.
4. The Student Health Service fails to authenticate their identity and is not provided with a secure access token.
5. Incoming data is not accepted to the data lake.
6. The health service receives an error message to provide valid credentials.

Additionally, we also have the following exceptional flow:

1. A patient attends the Student Health Service with a condition. 
2. A healthcare practitioner diagnoses this condition.
3. The Student Health Service wishes to send this data to the data lake.
4. The Student Health Service authenticates their identity and is provided with a secure access token.
5. Incoming data is not in an acceptable format matching the FHIR standard.
6. Data is not accepted into the data lake.
7. The healthcare service receives an error message to provide data in standard format.

In addition we have other interacting stakeholders such as the Bristol Royal Infirmary, Southmead Hospital, other GP practices and healthcare services in the Bristol, North Somerset and South Gloucestershire area. These healthcare services will have similar user stories to the the University of Bristol Student Health Service:

- A patient attends a healthcare service for a body imaging scan or measurement. This data can then be submitted to the data lake for secure storage and analysis. 
- A patient attends a healthcare service for an operation. This data can then be submitted to the data lake for secure storage and analysis. 
- A patient attends a private healthcare clinic. The record of the appointment and any actions can still be sent to the data lake for analysis.

In addition to these interacting stakeholders, we have some non-interacting stakeholders.
One of these is the general public, who expect high-quality public health care. They are stakeholders in this software due to its use in allowing data based decisions on what areas of healthcare need improvement and where additional services need to be commissioned. 
In addition a non-interacting stakeholder group are healthcare workers. Although they won't be interacting with the system directly, the software can be used to inform decisions which can be of great importance to them, such as number of GPs surgeries or district nurses required in a particular local area.  

### Requirements

Using these user stories above, we can decompose our flow steps into atomic implementation features (requirements) that we can use to assess the functionality of our software.

We have identified these core requirements for the functionality of our software:

1. An identity authentication process provides healthcare providers
    with credentials to supply data to an API. The identity authentication process must
    1. Ensure only that an access token is only provided to authorised users.
    
2. An API takes in data from local healthcare providers as a HL7
    FHIR message. We have chosen HL7 FHIR as it is the [UK standard for
    transferring
    healthcare messages.](https://digital.nhs.uk/services/fhir-uk-core) The API must:
    1. Ensure messages sent with an invalid access token are not accepted into the data lake and an appropriate error code is supplied.
    2. Ensure messages sent in a non-valid format are not accepted into the data lake and an appropriate error code is supplied.
    3. Ensure messages sent with a valid access token and in a valid FHIR format are accepted into the data lake, and an acceptance message is supplied. 

3. These data messages are transformed into a well structured common data model and stored in a cloud solution. We have chosen the OMOP common data model as it allows data to be standardised to allow for analytics from a range of sources. This must:
    1. Transform data from the received FHIR format to the OMOP common data model.
    2. Store data in a suitable format in OMOP form in the data lake.
    3. Ensure the data lake is regularly incrementally updated to include any new messages that have been received. 
4. The stored data is catalogued to allow for analysis. This must produce meta-data of the stored data.
5. A commercial ETL tool is used to curate data marts.
6. These data marts can be queried by the analytics environment.

We have also identified a set of additional requirements:

1.  Medical data is to be stored independently from pseudonymised
    patient identifiers.
2.  Provide a user console to monitor automated ETL jobs. 
3.  Provide full audit trails.

We can then use these requirements to test our developed software solution. 


## Personal Data, Privacy, Security and Ethics Management

### GDPR

The data lake solution developed by the “Healthcare Data Lake” project team is an integrating part of the larger prototype system, alongside ”Healthcare Data Simulation” and ”Healthcare Analytics” teams. The proposed system is going to be used in compliance with the NHS Digital GDPR compliance implementation and the liability for the personal data stored falls onto the respective primary stakeholder, Philip Harfield at Bristol, North Somerset and South Gloucestershire CCG (BNSSG).

The team developing the data lake infrastructure is responsible for creating a prototype secure, robust and scalable health data storage platform used for ingesting and interrogating patient’s data under the HL7 FHIR standard. User consent and data collection is not handled by the team as the datalake only ingests external data. As a client-specified requirement, medical data is going to be stored with pseudonymised patient identifiers, thus protecting the identity and integrity of the patients whose data is stored in the data lake. The patient data is transformed to population-level data model (OMOP CDM) for the purpose of large-scale analysis.  
The Data Lake team does not use the processed data. The responsability for the use of the processed data falls onto the end user (Data Analytics Team).

### Privacy

The Healthcare Lake project does not disclose, use, copy, publish or modify in any way the stored patient data. The patient records are ingested with the sole purpose of storage and curation. The process of transforming the data to the OMOP Common Data Model is internal, automated and independent. The data is solely and securely made available to the Data Analytics team which has to guarantee the further privacy of it.

### Security

Having to work with medical data, the security requirements for this prototype are high. The security of the Data Lake is guaranteed by the cloud provider's own security (in this case AWS). User policies and private S3 buckets ensure that the lake is not accessible by outsiders. The API can be only used with a token that is generated after logging into a user account created by the admin, so only authorized users/entities will be able to send data through the API.

There will be no outbound communication from inside the data lake and the only inbound connection is data ingestion from the client API. All curated data marts are accessible from the lake S3 bucket via VPC or ACL with the Data Analytics team who are responsible for the security of their environment in which they deploy their processes. All access to these will be logged and anomalies, violations and exceptions will be flagged for alerts and auditing using AWS Cloudwatch. Furthermore, this storage of curated data marts is in a private network separate from the rest of the data lake in any case. A comprehensive look at this architecture is included in the Architecture section this paper.

### Ethics

Ethics pre-approval was applied for on 19 November 2020, 12:00 GMT. The data handled in the project is simulated patients data supplied by the Healthcare Data Simulation project. The Healthcare Lake project does not collect any data from any real person nor handles any consent, as the scope of the project is to create a secure infrastructure for storing patients data.
In case of future development and testing with actual patients data, separate ethics approvals will be required, NHS REC review as it involves patients and governance approvals (e.g. Health Research Authority HRA). 

## Architecture

## Development Testing

## Release Testing

## OO Design & UML

## Acceptance Testing (Evaluation)

## Reflection
