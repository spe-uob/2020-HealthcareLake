# Healthcare Data Lake - Portfolio B

## Overview

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

For example, one of these stakeholders will be the Bristol Student Health GP service.  This service offers GP healthcare to the majority of students at the University of Bristol and would have the following user stories when interacting with our software.

- A student may attend their GP with a health concern, which a GP can diagnose. A record of this can be sent to the data lake to be securely stored and used in analysis.
- A student may have a measurement taken when attending the GP, for example a height, weight or blood pressure measurement. This measurement can be then sent to the data lake to be stored with their record. A healthcare organisation could then monitor change over time or carry out other analytics.
- Finally a patient could contact the GP service to update their details, such as an address. This update of data can then be stored in the data lake to ensure that data is up to date.

Now considering the first user story above, we can break down the story into flow steps.

1. A patient attends the Student Health Service with a condition. 
2. A GP diagnoses this condition.
3. The Student Health Service wishes to send this data to the data lake.
3. The Student Health Service authenticates their identity and is provided with a secure access token.
4. The data is sent to the data lake securely via an API in the format of a FHIR message (industry standard for healthcare information)
5. The data is accepted by the API and an acceptance message is sent to the GP service.
6. The data is converted to a common data model format and securely stored.
7. The data can be queried and analysed as required.

We can also identify exceptional flow for this user story:

1. A patient attends the Student Health Service with a condition. 
2. A GP diagnoses this condition.
3. The Student Health Service wishes to send this data to the data lake.
4. The Student Health Service fails to authenticate their identity and is not provided with a secure access token.
5. Incoming data is not accepted to the data lake.
6. The health service receives an error message to provide valid credentials.

Additionally, we also have the following exceptional flow:

1. A patient attends the Student Health Service with a condition. 
2. A GP diagnoses this condition.
3. The Student Health Service wishes to send this data to the data lake.
4. The Student Health Service authenticates their identity and is provided with a secure access token.
5. Incoming data is not in an acceptable format matching the FHIR standard.
6. Data is not accepted into the data lake.
7. The healthcare service receives an error message to provide data in standard format.

In addition we have other interacting stakeholders such as the Bristol Royal Infirmary, Southmead Hospital, other GP practices and healthcare services in the Bristol, North Somerset and South Gloucestershire area. These healthcare services will have similar user stories to the the Bristol Student Health Service:

- A patient attends a healthcare service for a body imaging scan or measurement. This data can then be submitted to the data lake for secure storage and analysis. 
- A patient attends a healthcare service for an operation. This data can then be submitted to the data lake for secure storage and analysis. 
- A patient attends a private healthcare clinic. The record of the appointment and any actions can still be sent to the data lake for analysis.

In addition to these interacting stakeholders, we have some non-interacting stakeholders.
One of these is the general public, who expect high-quality public health care. They are stakeholders in this software due to its use in allowing data based decisions on what areas of healthcare need improvement and where additional services need to be commissioned. 
In addition a non-interacting stakeholder group are healthcare workers. Although they won't be interacting with the system directly, the software can be used to inform decisions which can be of great importance to them, such as number of GPs surgeries or district nurses required in a particular local area.  


## Personal Data, Privacy, Security and Ethics Management

## Architecture

## Development Testing

## Release Testing

## OO Design & UML

## Acceptance Testing (Evaluation)

## Reflection
